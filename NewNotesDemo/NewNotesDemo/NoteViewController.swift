//
//  NoteViewController.swift
//  NewNotesDemo
//
//  Created by suram.tejaswini on 03/07/19.
//  Copyright © 2019 suram.tejaswini. All rights reserved.
//

import Cocoa

class NoteViewController: NSViewController ,NSTextViewDelegate{

    @IBOutlet var noteViiew: NSTextView!
      var uuid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.noteViiew.delegate = self
        
    }
    
    func textDidChange(_ notification: Notification) {
        let timestamp = DateFormatter.localizedString(from:Date(), dateStyle: .medium, timeStyle: .short)
      self.view.window?.title = timestamp  
        self.saveNotesDetails()
    }
    func setUpConfig(data: String?,title:String?,uUID:String?)  {
        if uUID == ""{
            uuid = UUID().uuidString
        }else{
            uuid = uUID
        }
        self.view.window?.title = title!
        self.noteViiew.string = data!
        
       
        let b = NSUserInterfaceItemIdentifier.init(uuid!)
        self.identifier = b
        
    }
    func saveNotesDetails(){
        guard self.noteViiew.string != "" else {return}
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
        newNoteDetail.setValue(self.noteViiew.string, forKey: NOTES_CONTENT)
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
