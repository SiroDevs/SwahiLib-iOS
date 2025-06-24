//
//  ProverbDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class ProverbDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveProverbs(_ proverbs: [Proverb]) {
        context.perform {
            do {
                for proverb in proverbs {
                    let fetchRequest: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", proverb.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdProverb: CDProverb

                    if let existingRecord = existingRecords.first {
                        cdProverb = existingRecord
                    } else {
                        cdProverb = CDProverb(context: self.context)
                    }

                    // Safely set values
                    cdProverb.id = Int32(proverb.id)
                    cdProverb.rid = Int32(proverb.rid)
                    cdProverb.title = proverb.title
                    cdProverb.meaning = proverb.meaning
                    cdProverb.views = Int32(proverb.views)
                    cdProverb.likes = Int32(proverb.likes)
                    cdProverb.liked = proverb.liked
                    cdProverb.createdAt = proverb.createdAt
                    cdProverb.updatedAt = proverb.updatedAt
                }

                try self.context.save()
            } catch {
                print("Failed to save proverbs: \(error)")
            }
        }
    }
    
    // Fetch all proverbs
    func fetchProverbs() -> [Proverb] {
        let fetchRequest: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()        
        do {
            let cdProverbs = try context.fetch(fetchRequest)
            return cdProverbs.map { cdProverb in
                return Proverb(
                    id: Int(cdProverb.id),
                    rid: Int(cdProverb.rid),
                    title: cdProverb.title ?? "",
                    synonyms: cdProverb.synonyms ?? "",
                    meaning: cdProverb.meaning ?? "",
                    conjugation: cdProverb.conjugation ?? "",
                    views: Int(cdProverb.views),
                    likes: Int(cdProverb.likes),
                    liked: cdProverb.liked,
                    createdAt: cdProverb.createdAt ?? "",
                    updatedAt: cdProverb.updatedAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch proverbs: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchProverb(withId id: Int) -> Proverb? {
        let fetchRequest: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdProverb = results.first else { return nil }
            
            return Proverb(
                id: Int(cdProverb.id),
                rid: Int(cdProverb.rid),
                title: cdProverb.title ?? "",
                synonyms: cdProverb.synonyms ?? "",
                meaning: cdProverb.meaning ?? "",
                conjugation: cdProverb.conjugation ?? "",
                views: Int(cdProverb.views),
                likes: Int(cdProverb.likes),
                liked: cdProverb.liked,
                createdAt: cdProverb.createdAt ?? "",
                updatedAt: cdProverb.updatedAt ?? "",
            )
        } catch {
            print("Failed to fetch proverb: \(error)")
            return nil
        }
    }
    
    func updateProverb(_ proverb: Proverb) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", proverb.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdProverb = try self.context.fetch(fetchRequest).first {
                    cdProverb.title = proverb.title
                    cdProverb.meaning = proverb.meaning
                    cdProverb.conjugation = proverb.conjugation
                    cdProverb.synonyms = proverb.synonyms
                    cdProverb.liked = proverb.liked
                    
                    try self.context.save()
                } else {
                    print("Proverb with ID \(proverb.id) not found.")
                }
            } catch {
                print("Failed to update proverb: \(error)")
            }
        }
    }

    func deleteProverb(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let proverbToDelete = results.first {
                context.delete(proverbToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete proverb: \(error)")
        }
    }
}
