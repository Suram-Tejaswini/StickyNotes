//
//  SubMenuWindowController.swift
//  NewSubMenu
//
//  Created by suram.tejaswini on 19/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class SubMenuWindowController: NSWindowController,NSTableViewDataSource,NSTableViewDelegate,NSSearchFieldDelegate {
    var arraylist = ["Apple","Mango","Orange","Grapes","Sapota","Strawberry"]
    var searchList = [String]()
    var notesListForSearch :[String:String] = [String:String]()
    var listOfNotes = [String]()
    @IBOutlet weak var listView: NSScrollView!
    @IBOutlet weak var subMenuView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchFieldOutlet: NSSearchField!
    
    lazy var appDelegate =  NSApplication.shared.delegate as! AppDelegate
    let searchItem :NSMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
   
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        listOfNotes = Array(fetchDetails().values)
        self.searchFieldOutlet.delegate = self
        self.listView.isHidden = false
        self.cofigureSearchDataMenu(itemsList: listOfNotes)
    }
    
    func cofigureSearchDataMenu(itemsList:[String]){
        searchList = itemsList
        self.tableView.reloadData()
    }
    
    // for fetching data
    
    func fetchDetails()->[String: String]  {
        
        guard  let appDelegate = NSApplication.shared.delegate as? AppDelegate else{ return[:] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentDate")
        do {
            let datesList = try managedContext.fetch(fetchRequest)
           
            for i in 0..<datesList.count{
                if  let data:NSManagedObject =  datesList[i].value(forKeyPath:"currentNotes")as? NSManagedObject, let date:String = datesList[i].value(forKeyPath:"cDate") as? String {
                    let returnedNote:String = data.value(forKeyPath: "notes") as! String
                    notesListForSearch.updateValue(returnedNote, forKey: date )
                }
            }
            arraylist = Array(notesListForSearch.values)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return notesListForSearch
    }
    
    @IBAction func controlTextDidChange_Custom(obj: NSSearchField!) {
        if (!obj.stringValue.isEmpty) {
           // print("Searched: \(obj.stringValue)")
            let searchString = searchFieldOutlet.stringValue
//            searchList = arraylist.filter{$0.lowercased().hasPrefix(searchString.lowercased())}
           searchList = arraylist.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercased().range(of: searchString.lowercased())
                return stringMatch != nil ? true : false
            })
            print(searchList)
            if searchList.count>0{
                self.tableView .reloadData()
                self.listView.isHidden = false
            }
            else{
                self.listView.isHidden = true
            }
        } else {
            print("EMPTY")
            searchList = arraylist
            self.listView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
extension SubMenuWindowController {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return searchList.count
    }
    
}
extension SubMenuWindowController {
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = searchList[row]
        return cell
    }
    
}


