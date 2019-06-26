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
   
    @IBOutlet weak var statusMenu: NSMenu!
    var notesListForDate:Dictionary = [String:String]()
    var notesList:[Dictionary] = [[String:String]]()
    
    var newNoteWindowController : NewNote!
    var subMenuWindowController : SubMenuWindowController!
    
    var searchItem :NSMenuItem = NSMenuItem(title: "", action:nil, keyEquivalent: "")
    var statusItem:NSStatusItem? = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
       
       // Insert code here to initialize your application
        self.statusItem?.button?.title = "NotesDemo"
        statusItem?.menu = statusMenu
        statusItem!.button?.cell?.isHighlighted = true
        configureNotesDetails()
       
        self.subMenuWindowController = SubMenuWindowController.init(windowNibName: "SubMenuWindowController")
        searchItem.view = subMenuWindowController?.window?.contentView

        self.subMenu.addItem(searchItem)
       // deleteAllRecords()  // for testing
    }
   
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func deleteAllRecords() {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentDate")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let deleteFetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: deleteFetch1)
        
        do {
            try context.execute(deleteRequest)
            try context.execute(deleteRequest1)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func configureNotesDetails(){
        let notesDetails : [String:String] =  fetchDetails()
        for (key,value) in notesDetails{
            newNoteWindowController = NewNote(windowNibName: "NewNote")
            newNoteWindowController.setUpConfig(data: value,title:key)
            self.newNoteWindowController.showWindow(nil)
        }
    }
    
    func fetchDetails() -> [String:String]{
    
    guard  let appDelegate = NSApplication.shared.delegate as? AppDelegate else{ return [:] }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentDate")
    // let fetchDateRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentDate")
    do {
    let datesList = try managedContext.fetch(fetchRequest)
   
    for i in 0..<datesList.count{
    if  let data:NSManagedObject =  datesList[i].value(forKeyPath:"currentNotes")as? NSManagedObject, let date:String = datesList[i].value(forKeyPath:"cDate") as? String {
    let returnedNote:String = data.value(forKeyPath: "notes") as! String
    notesListForDate.updateValue(returnedNote, forKey: date )
        }
        }
    } catch let error as NSError {
    print("Could not fetch. \(error), \(error.userInfo)")
    }
    return notesListForDate
    }
    
    @IBAction func showNotesList(_ sender:Any){
        subMenuWindowController.cofigureSearchDataMenu(itemsList: Array(fetchDetails().values))
        searchItem.view = subMenuWindowController?.window?.contentView
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        if  newNoteWindowController != nil{
            saveDetails()
        }
        newNoteWindowController = NewNote(windowNibName: "NewNote")
        newNoteWindowController?.showWindow(nil)
    }
    
    @IBAction func showPrferences(_ sender: Any) {
     saveDetails()
    }
    
    @IBAction func quitTheApp(_ sender: Any) {
        saveDetails()
        NSApplication.shared.terminate(self)
    }
    
    @objc func saveDetails()  {
        let timestamp = DateFormatter.localizedString(from:Date(), dateStyle: .medium, timeStyle: .long)
        saveNotesDetails(note:(self.newNoteWindowController?.notesView!.string)!, date: timestamp)
    }
    
    func saveNotesDetails(note:String,date:String){
    
    guard  let appDelegate = NSApplication.shared.delegate as? AppDelegate else{ return }
    
    let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    //create date
    let dateEntity = NSEntityDescription.entity(forEntityName: "CurrentDate", in: managedContext)
    let newDate = NSManagedObject(entity: dateEntity!, insertInto: managedContext)
        
    //populate date
    newDate.setValue(date, forKey: "cDate")
    
    //create Note
    let notesEntity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)
    let newNote = NSManagedObject(entity: notesEntity!, insertInto: managedContext)
    
    //Populate Note
    newNote.setValue(note, forKey: "notes")
    
    // Add note to date
    newDate.setValue(newNote, forKey: "currentNotes")
    
    do {
    try managedContext.save()
    } catch let error as NSError {
    print("Could not save. \(error), \(error.userInfo)")
    }
        
}
  
     // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NotesDetails")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving and Undo support
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }
    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
 

}



