//
//  SubMenuViewController.swift
//  NewNotesDemo
//
//  Created by suram.tejaswini on 04/07/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class SubMenuViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSSearchFieldDelegate {
    
    @IBOutlet weak var searchFieldOutlet: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var listView: NSScrollView!
    
    var searchList  = Dictionary<String,Dictionary<String, String> >()
    var newNoteWindowController : NewNote!
    var notesListForSearch :Dictionary <String,Dictionary> = [String:Dictionary<String,String>]()
    lazy var appDelegate =  NSApplication.shared.delegate as! AppDelegate
    let searchItem :NSMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
    
    func controlTextDidChange(_ notification: Notification) {
         guard let field = notification.object as? NSSearchField, field == self.searchFieldOutlet else { return }
        if (!field.stringValue.isEmpty) {
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
extension SubMenuViewController {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return searchList.count
    }
    
}
extension SubMenuViewController {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = Array(searchList.values)[row][NOTES_CONTENT]!
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification){
        
        print("selected")
        let selectedCell = notification.object as! NSTableView
        let selectedData = Array(searchList)[selectedCell.selectedRow]
        let displayingWindows = NSApplication.shared.windows
        let existedWindows = displayingWindows.filter({$0.contentViewController?.identifier!.rawValue == selectedData.key})
        if existedWindows.count == 0{
            newNoteWindowController = NewNote(windowNibName: "NewNote")
            newNoteWindowController?.setUpConfig(data: selectedData.value[NOTES_CONTENT]!, title: selectedData.value[NOTES_TITLE]!, uUID: selectedData.key)
            newNoteWindowController!.showWindow(nil)
            newNoteWindowController?.window!.makeKeyAndOrderFront(nil)
        } else{
            existedWindows[0].makeKeyAndOrderFront(selectedCell)
        }
    }
}

