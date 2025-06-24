//
//  SayingDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class SayingDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveSayings(_ sayings: [Saying]) {
        context.perform {
            do {
                for saying in sayings {
                    let fetchRequest: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", saying.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdSaying: CDSaying

                    if let existingRecord = existingRecords.first {
                        cdSaying = existingRecord
                    } else {
                        cdSaying = CDSaying(context: self.context)
                    }

                    // Safely set values
                    cdSaying.id = Int32(saying.id)
                    cdSaying.rid = Int32(saying.rid)
                    cdSaying.title = saying.title
                    cdSaying.meaning = saying.meaning
                    cdSaying.views = Int32(saying.views)
                    cdSaying.likes = Int32(saying.likes)
                    cdSaying.liked = saying.liked
                    cdSaying.createdAt = saying.createdAt
                    cdSaying.updatedAt = saying.updatedAt
                }

                try self.context.save()
            } catch {
                print("Failed to save sayings: \(error)")
            }
        }
    }
    
    // Fetch all sayings
    func fetchSayings() -> [Saying] {
        let fetchRequest: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()        
        do {
            let cdSayings = try context.fetch(fetchRequest)
            return cdSayings.map { cdSaying in
                return Saying(
                    id: Int(cdSaying.id),
                    rid: Int(cdSaying.rid),
                    title: cdSaying.title ?? "",
                    meaning: cdSaying.meaning ?? "",
                    views: Int(cdSaying.views),
                    likes: Int(cdSaying.likes),
                    liked: cdSaying.liked,
                    createdAt: cdSaying.createdAt ?? "",
                    updatedAt: cdSaying.updatedAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch sayings: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchSaying(withId id: Int) -> Saying? {
        let fetchRequest: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSaying = results.first else { return nil }
            
            return Saying(
                id: Int(cdSaying.id),
                rid: Int(cdSaying.rid),
                title: cdSaying.title ?? "",
                meaning: cdSaying.meaning ?? "",
                views: Int(cdSaying.views),
                likes: Int(cdSaying.likes),
                liked: cdSaying.liked,
                createdAt: cdSaying.createdAt ?? "",
                updatedAt: cdSaying.updatedAt ?? "",
            )
        } catch {
            print("Failed to fetch saying: \(error)")
            return nil
        }
    }
    
    func updateSaying(_ saying: Saying) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", saying.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdSaying = try self.context.fetch(fetchRequest).first {
                    cdSaying.title = saying.title
                    cdSaying.meaning = saying.meaning
                    cdSaying.liked = saying.liked
                    
                    try self.context.save()
                } else {
                    print("Saying with ID \(saying.id) not found.")
                }
            } catch {
                print("Failed to update saying: \(error)")
            }
        }
    }

    func deleteSaying(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let sayingToDelete = results.first {
                context.delete(sayingToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete saying: \(error)")
        }
    }
}
