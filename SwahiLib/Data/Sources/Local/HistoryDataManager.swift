//
//  HistoryDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class HistoryDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveHistories(_ histories: [History]) {
        context.perform {
            do {
                for history in histories {
                    let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "historyId == %d", history.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdHistory: CDHistory

                    if let existingRecord = existingRecords.first {
                        cdHistory = existingRecord
                    } else {
                        cdHistory = CDHistory(context: self.context)
                    }

                    // Safely set values
                    cdHistory.id = Int32(history.id)
                    cdHistory.item = Int32(history.item)
                    cdHistory.type = history.type
                    cdHistory.createdAt = history.createdAt
                }

                try self.context.save()
            } catch {
                print("Failed to save historys: \(error)")
            }
        }
    }
    
    // Fetch all historys or histories for a specific item
    func fetchHistories() -> [History] {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        do {
            let cdHistories = try context.fetch(fetchRequest)
            return cdHistories.map { cdHistory in
                return History(
                    id: Int(cdHistory.id),
                    item: Int(cdHistory.item),
                    type: cdHistory.type ?? "",
                    createdAt: cdHistory.createdAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch historys: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchHistory(withId id: Int) -> History? {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "historyId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdHistory = results.first else { return nil }
            
            return History(
                id: Int(cdHistory.id),
                item: Int(cdHistory.item),
                type: cdHistory.type ?? "",
                createdAt: cdHistory.createdAt ?? "",
            )
        } catch {
            print("Failed to fetch history: \(error)")
            return nil
        }
    }
    
    func updateHistory(_ history: History) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "historyId == %d", history.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdHistory = try self.context.fetch(fetchRequest).first {
                    cdHistory.type = history.type
                    try self.context.save()
                } else {
                    print("History with ID \(history.id) not found.")
                }
            } catch {
                print("Failed to update history: \(error)")
            }
        }
    }

    func deleteHistory(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "historyId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let historyToDelete = results.first {
                context.delete(historyToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
}
