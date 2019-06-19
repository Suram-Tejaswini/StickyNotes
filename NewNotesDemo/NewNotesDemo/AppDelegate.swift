//
//  AppDelegate.swift
//  NewNotesDemo
//
//  Created by suram.tejaswini on 18/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate ,NSSearchFieldDelegate,NSMenuDelegate{

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var subMenu: NSMenu!
    @IBOutlet weak var searchNotes: NSSearchField!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let note = NotesDetail()
    var listOfNotes = [String]()
    
    var newNoteWindowController : NSWindowController?
    var subMenuWindowController : NSWindowController?
    
    var searchItem :NSMenuItem = NSMenuItem(title: "", action:nil, keyEquivalent: "")
    var statusItem:NSStatusItem? = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
       
       // Insert code here to initialize your application
        self.statusItem?.button?.title = "NotesDemo"
        statusItem?.menu = statusMenu
        statusItem!.button?.cell?.isHighlighted = true
        self.searchNotes.delegate = self
        self.subMenu.delegate = self
        searchItem.view = self.searchNotes
        self.subMenu.addItem(searchItem)
        listOfNotes = note.arraylist
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showNotesList(_ sender: Any) {
      
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        
        newNoteWindowController = NSWindowController(windowNibName: "NewNote")
        newNoteWindowController?.showWindow(nil)

    }
    @IBAction func showPrferences(_ sender: Any) {
     
    }
    @IBAction func quitTheApp(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
   
  
    func menuNeedsUpdate(_ menu: NSMenu) {
         note.configureSubMenuWithItems(notesList: listOfNotes)
    }

    func controlTextDidChange(_ obj: Notification) {
        print("done")
        let searchString = searchNotes.stringValue
        if searchString != "" {
            listOfNotes.removeAll()
            let notesArray = note.arraylist
            listOfNotes = notesArray.filter{$0.lowercased().hasPrefix(searchString.lowercased())}
            self.menuNeedsUpdate(subMenu)
        }else{
           let notesArray = note.arraylist
            self.menuNeedsUpdate(subMenu)
    }
}
}



