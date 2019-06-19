//
//  NewNote.swift
//  NotesAppDemo
//
//  Created by suram.tejaswini on 17/06/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class NewNote: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    override init(window: NSWindow?) {
        
        super.init(window:nil)
        shouldCascadeWindows = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
