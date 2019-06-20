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
   
    @IBOutlet weak var listView: NSScrollView!
    @IBOutlet weak var subMenuView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchFieldOutlet: NSSearchField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchFieldOutlet.delegate = self
        self.listView.isHidden = false
        searchList = arraylist
    }
    
        lazy var appDelegate =  NSApplication.shared.delegate as! AppDelegate
        let searchItem :NSMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

    
    @IBAction func controlTextDidChange_Custom(obj: NSSearchField!) {
        
        
        if (!obj.stringValue.isEmpty) {
            print("Searched: \(obj.stringValue)")
            let searchString = searchFieldOutlet.stringValue
            //searchOutlet.sendsSearchStringImmediately = true
            
            searchList = arraylist.filter{$0.lowercased().hasPrefix(searchString.lowercased())}
            //        self.searchOutlt.searchMenuTemplate = searchesMenu
            //        searchOutlt.recentSearches = newArr
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


