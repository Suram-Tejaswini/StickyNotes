//
//  NotesDetail.swift
//  NewNotesDemo
//
//  Created by suram.tejaswini on 18/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class NotesDetail: NSWindowController ,NSTextFieldDelegate{

    @IBOutlet var searchBarOutlet: NSSearchField!
    
    var arraylist = ["Apple","Mango","Orange","Grapes","Sapota","Strawberry"]
   
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func configureSubMenuWithItems(notesList:[String]) {
        let appDelegate =  NSApplication.shared.delegate as! AppDelegate
        appDelegate.subMenu.removeAllItems()
        appDelegate.subMenu.addItem(appDelegate.searchItem)
        for item in notesList {
            appDelegate.subMenu?.addItem(withTitle: item, action: #selector(itemSelectedForEdit), keyEquivalent: "6").target = self
        }
    }
    
    @objc func itemSelectedForEdit()  {
        let newNoteWindowController = NSWindowController(windowNibName: "NewNote")
        newNoteWindowController.showWindow(self)
        newNoteWindowController.window?.makeKeyAndOrderFront(nil)
    }
   
}
