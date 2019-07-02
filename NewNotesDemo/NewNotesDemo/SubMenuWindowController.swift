//
//  SubMenuWindowController.swift
//  NewSubMenu
//
//  Created by suram.tejaswini on 19/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class SubMenuWindowController: NSWindowController,NSTableViewDataSource,NSTableViewDelegate,NSSearchFieldDelegate {
    
    var searchList  = Dictionary<String,Dictionary<String, String> >()
    
    var notesListForSearch :Dictionary <String,Dictionary> = [String:Dictionary<String,String>]()
  
    var newNoteWindowController : NewNote?
    
    @IBOutlet weak var listView: NSScrollView!
    @IBOutlet weak var subMenuView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchFieldOutlet: NSSearchField!
    
    lazy var appDelegate =  NSApplication.shared.delegate as! AppDelegate
    let searchItem :NSMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
   
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func cofigureSearchDataMenu(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchFieldOutlet.delegate = self
        self.listView.isHidden = false
        searchList = fetchDetails()
        self.tableView.reloadData()
    }
    
    // for fetching data
    
    func fetchDetails() -> Dictionary<String,Dictionary<String, String>> {
        
        guard  let appDelegate = NSApplication.shared.delegate as? AppDelegate else{ return[:] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTE_KEY)
        do {
            let datesList = try managedContext.fetch(fetchRequest)
            for i in 0..<datesList.count{
                let noteKey = (datesList[i].value(forKey:NOTES_UKEY)as? String)!
                let managedObject:NSManagedObject = datesList[i].value(forKey: NOTES_DETAIL)as! NSManagedObject
                if  let data:String = managedObject.value(forKeyPath:NOTES_CONTENT)as? String, let date:String = managedObject.value(forKeyPath:NOTES_TITLE) as? String {
                    let notesDict:Dictionary = [NOTES_TITLE:date,NOTES_CONTENT:data]
                    notesListForSearch.updateValue(notesDict, forKey: noteKey )
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return notesListForSearch
    }
    
    @IBAction func controlTextDidChange_Custom(obj: NSSearchField!) {
        if (!obj.stringValue.isEmpty) {
            let searchString = searchFieldOutlet.stringValue
            let noteslist = notesListForSearch
            searchList = noteslist.filter({$0.value[NOTES_CONTENT]!.lowercased().contains((searchString.lowercased()) )})
            //print(searchList)
            if searchList.count>0{
                self.tableView .reloadData()
                self.listView.isHidden = false
            }else{
                self.listView.isHidden = true
            }
        } else {
            //print("EMPTY")
            searchList = notesListForSearch
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
        //let dictValue :Array = Array(Array(searchList.values)[row].values)
        cell?.textField?.stringValue = Array(searchList.values)[row][NOTES_CONTENT]!
        return cell
    }
    
   func tableViewSelectionDidChange(_ notification: Notification){
     let selectedCell = notification.object as! NSTableView
     let selectedData = Array(searchList)[selectedCell.selectedRow]
    newNoteWindowController = NewNote(windowNibName: "NewNote")
    newNoteWindowController?.setUpConfig(data: selectedData.value[NOTES_CONTENT]!, title: selectedData.value[NOTES_TITLE]!, uUID: selectedData.key)
    newNoteWindowController!.showWindow(nil)
    }
}


