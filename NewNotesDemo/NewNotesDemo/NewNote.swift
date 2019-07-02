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
    @IBOutlet var notesView: NSTextView!
 
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        shouldCascadeWindows = true
        self.notesView?.delegate = self
        uuid = UUID().uuidString
    }
    override init(window: NSWindow?) {
        super.init(window:nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setUpConfig(data: String,title:String,uUID:String)  {
        self.window?.title = title
        self.notesView.string = data
        uuid = uUID
    }
    func textDidChange(_ notification: Notification) {
        
       let timestamp = DateFormatter.localizedString(from:Date(), dateStyle: .medium, timeStyle: .short)
        self.window?.title = timestamp
        self.saveNotesDetails()
    }
    
    func saveNotesDetails(){
        guard self.notesView.string != "" else {return}
        let timestamp = DateFormatter.localizedString(from:Date(), dateStyle: .medium, timeStyle: .short)
        guard  let appDelegate = NSApplication.shared.delegate as? AppDelegate else{ return }
    
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
        //create notekey
        let noteEntity = NSEntityDescription.entity(forEntityName: NOTE_KEY, in: managedContext)
        let newNote = NSManagedObject(entity: noteEntity!, insertInto: managedContext)
   
        //create Note
        let notesDetailEntity = NSEntityDescription.entity(forEntityName: NOTES, in: managedContext)
        let newNoteDetail = NSManagedObject(entity: notesDetailEntity!, insertInto: managedContext)
    
        //Populate Note
        newNoteDetail.setValue(self.notesView.string, forKey: NOTES_CONTENT)
        newNoteDetail.setValue(timestamp, forKey: NOTES_TITLE)
                
        //populate notekey
        newNote.setValue(uuid, forKey: NOTES_UKEY)

        // Add note to date
        newNote.setValue(newNoteDetail, forKey: NOTES_DETAIL)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }    
    
}
