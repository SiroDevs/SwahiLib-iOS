//
//  CoreDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 29/04/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwahiLib")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // Remove all data from Core Data (helpful for testing or resetting)
    func deleteAllData() {
        let context = viewContext
        
        // Delete all songs
        let songFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDSong")
        let songDeleteRequest = NSBatchDeleteRequest(fetchRequest: songFetchRequest)
        
        // Delete all books
        let bookFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDBook")
        let bookDeleteRequest = NSBatchDeleteRequest(fetchRequest: bookFetchRequest)
        
        do {
            try context.execute(songDeleteRequest)
            try context.execute(bookDeleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
}
