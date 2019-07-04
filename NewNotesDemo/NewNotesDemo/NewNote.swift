//
//  NewNote.swift
//  NotesAppDemo
//
//  Created by suram.tejaswini on 17/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class NewNote: NSWindowController ,NSTextViewDelegate{
    var uuid : String?
   
    //var contentViewController: ViewController!
    @IBOutlet var notesView: NSTextView!

    var noteViewController : NoteViewController!
    
    override func windowDidLoad() {
        super.windowDidLoad()
      
//  k = NoteViewController.init(nibName: "NoteViewController", bundle: nil)
//        self.window?.contentViewController = k
        
       //
        
//        noteViewController = NoteViewController.init(nibName: "NoteViewController", bundle: nil)
//        
//        self.window?.contentViewController = noteViewController
        setUpConfig(data:"", title: "Note", uUID: "")
 
    }
    override init(window: NSWindow?) {
        super.init(window:nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setUpConfig(data: String?,title:String?,uUID:String?)  {

        uuid = uUID
    
        noteViewController = NoteViewController.init(nibName: "NoteViewController", bundle: nil)

        self.window?.contentViewController = noteViewController
      
        noteViewController.setUpConfig(data: data, title: title, uUID: uUID)
        
    }

}
