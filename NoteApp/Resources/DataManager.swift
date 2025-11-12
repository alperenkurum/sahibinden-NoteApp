//
//  DataManager.swift
//  NoteApp
//
//  Created by Ibrahim Alperen Kurum on 10.11.2025.
//

import Foundation
import CoreData

protocol NoteStorage: AnyObject {
    func saveNote(note: Note)
    func deleteNote(noteId: UUID)
    func updateNote(with note: Note)
    func fetchAllNotes() -> [Note]
}

class DataManager {
    static let shared = DataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NoteCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func findNote(id: String) -> NoteCoreData? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NoteCoreData> = NoteCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print(error)
            return nil
        }
    }
    
    func note(title: String, context: String, checked: Bool, id: String) -> NoteCoreData{
        let note = NoteCoreData(context: persistentContainer.viewContext)
        note.title = title
        note.context = context
        note.selected = checked
        note.id = id
        return note
    }
    
    func notes() -> [NoteCoreData] {
        let request: NSFetchRequest<NoteCoreData> = NoteCoreData.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }
}
