//
//  IdiomDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class IdiomDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveIdioms(_ idioms: [Idiom]) {
        context.perform {
            do {
                for idiom in idioms {
                    let fetchRequest: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", idiom.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdIdiom: CDIdiom

                    if let existingRecord = existingRecords.first {
                        cdIdiom = existingRecord
                    } else {
                        cdIdiom = CDIdiom(context: self.context)
                    }

                    // Safely set values
                    cdIdiom.rid = Int32(idiom.rid)
                    cdIdiom.title = idiom.title
                    cdIdiom.meaning = idiom.meaning
                    cdIdiom.views = Int32(idiom.views)
                    cdIdiom.likes = Int32(idiom.likes)
                    cdIdiom.liked = idiom.liked
                    cdIdiom.createdAt = idiom.createdAt
                    cdIdiom.updatedAt = idiom.updatedAt
                }

                try self.context.save()
            } catch {
                print("Failed to save idioms: \(error)")
            }
        }
    }
    
    // Fetch all idioms
    func fetchIdioms() -> [Idiom] {
        let fetchRequest: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()        
        do {
            let cdIdioms = try context.fetch(fetchRequest)
            return cdIdioms.map { cdIdiom in
                return Idiom(
                    rid: Int(cdIdiom.rid),
                    title: cdIdiom.title ?? "",
                    meaning: cdIdiom.meaning ?? "",
                    views: Int(cdIdiom.views),
                    likes: Int(cdIdiom.likes),
                    liked: cdIdiom.liked,
                    createdAt: cdIdiom.createdAt ?? "",
                    updatedAt: cdIdiom.updatedAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch idioms: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchIdiom(withId id: Int) -> Idiom? {
        let fetchRequest: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdIdiom = results.first else { return nil }
            
            return Idiom(
                rid: Int(cdIdiom.rid),
                title: cdIdiom.title ?? "",
                meaning: cdIdiom.meaning ?? "",
                views: Int(cdIdiom.views),
                likes: Int(cdIdiom.likes),
                liked: cdIdiom.liked,
                createdAt: cdIdiom.createdAt ?? "",
                updatedAt: cdIdiom.updatedAt ?? "",
            )
        } catch {
            print("Failed to fetch idiom: \(error)")
            return nil
        }
    }
    
    func updateIdiom(_ idiom: Idiom) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", idiom.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdIdiom = try self.context.fetch(fetchRequest).first {
                    cdIdiom.title = idiom.title
                    cdIdiom.meaning = idiom.meaning
                    cdIdiom.liked = idiom.liked
                    
                    try self.context.save()
                } else {
                    print("Idiom with ID \(idiom.id) not found.")
                }
            } catch {
                print("Failed to update idiom: \(error)")
            }
        }
    }

    func deleteIdiom(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let idiomToDelete = results.first {
                context.delete(idiomToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete idiom: \(error)")
        }
    }
}
