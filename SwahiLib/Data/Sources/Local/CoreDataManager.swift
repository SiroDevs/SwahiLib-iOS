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
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error)")
            }

            if let dbPath = description.url?.path {
                print("📦 Core Data SQLite DB path:\n\(dbPath)")
            } else {
                print("⚠️ Could not determine Core Data DB path")
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
}
