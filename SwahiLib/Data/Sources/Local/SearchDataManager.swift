//
//  SearchDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class SearchDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveSearches(_ searchs: [Search]) {
        context.perform {
            do {
                for search in searchs {
                    let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "searchId == %d", search.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdSearch: CDSearch

                    if let existingRecord = existingRecords.first {
                        cdSearch = existingRecord
                    } else {
                        cdSearch = CDSearch(context: self.context)
                    }

                    // Safely set values
                    cdSearch.id = Int32(search.id)
                    cdSearch.title = search.title
                    cdSearch.createdAt = search.createdAt
                }

                try self.context.save()
            } catch {
                print("Failed to save searches: \(error)")
            }
        }
    }
    
    // Fetch all searchs or searchs for a specific book
    func fetchSearches() -> [Search] {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        do {
            let cdSearchs = try context.fetch(fetchRequest)
            return cdSearchs.map { cdSearch in
                return Search(
                    id: Int(cdSearch.id),
                    title: cdSearch.title ?? "",
                    createdAt: cdSearch.createdAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch searches: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchSearch(withId id: Int) -> Search? {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSearch = results.first else { return nil }
            
            return Search(
                id: Int(cdSearch.id),
                title: cdSearch.title ?? "",
                createdAt: cdSearch.createdAt ?? "",
            )
        } catch {
            print("Failed to fetch search: \(error)")
            return nil
        }
    }
    
    func updateSearch(_ search: Search) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "searchId == %d", search.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdSearch = try self.context.fetch(fetchRequest).first {
                    cdSearch.title = search.title
                    
                    try self.context.save()
                } else {
                    print("Search with ID \(search.id) not found.")
                }
            } catch {
                print("Failed to update search: \(error)")
            }
        }
    }

    func deleteSearch(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let searchToDelete = results.first {
                context.delete(searchToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete search: \(error)")
        }
    }
}
