//
//  NewNote.swift
//  NotesAppDemo
//
//  Created by suram.tejaswini on 17/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class NewNote: NSWindowController ,NSTextViewDelegate{

    @IBOutlet var notesView: NSTextView!
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        shouldCascadeWindows = true
        self.notesView?.delegate = self
    }
    override init(window: NSWindow?) {
        super.init(window:nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setUpConfig(data: String,title:String)  {
        self.window?.title = title
        self.notesView.string = data
    }
    func textDidChange(_ notification: Notification) {
       let timestamp = DateFormatter.localizedString(from:Date(), dateStyle: .medium, timeStyle: .short)
        self.window?.title = timestamp
    }   
}
