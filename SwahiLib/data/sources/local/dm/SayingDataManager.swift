//
//  SayingDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import CoreData

class SayingDataManager {
    private let coreDataManager: CoreDataManager
    lazy var bgContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = coreDataManager.viewContext
        return context
    }()
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    func saveSayings(_ cdSayings: [CDSaying]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    for cdSaying in cdSayings {
                        let newCdSaying = CDSaying(context: self.bgContext)
                        newCdSaying.rid = cdSaying.rid
                        newCdSaying.title = cdSaying.title ?? ""
                        newCdSaying.meaning = cdSaying.meaning ?? ""
                        newCdSaying.views = cdSaying.views
                        newCdSaying.likes = cdSaying.likes
                        newCdSaying.liked = cdSaying.liked
                        newCdSaying.createdAt = cdSaying.createdAt
                        newCdSaying.updatedAt = cdSaying.updatedAt
                    }
                    
                    try self.bgContext.save()
                    
                    Task { @MainActor in
                        do {
                            try self.context.save()
                            print("✅ \(cdSayings.count) sayings saved successfully")
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getSayingsByTitles(titles: [String]) -> [Saying] {
        let request: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        request.predicate = NSPredicate(format: "title IN %@", titles)
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch sayings: \(error)")
            return []
        }
    }

    func saveSaying(_ saying: Saying) {
        context.perform {
            do {
                let cdSaying = self.findOrCreateCd(by: saying.rid)
                MapEntityToCd.mapToCd(saying, cdSaying)
                try self.context.save()
            } catch {
                print("❌ Failed to save saying: \(error)")
            }
        }
    }

    func fetchSayings() -> [Saying] {
        let request: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch sayings: \(error)")
            return []
        }
    }

    func fetchSaying(withId id: Int) -> Saying? {
        fetchCd(by: id).map(MapCdToEntity.mapToEntity(_:))
    }

    func updateSaying(_ saying: Saying) {
        context.perform {
            guard let cdSaying = self.fetchCd(by: saying.id) else {
                print("⚠️ Saying with ID \(saying.id) not found.")
                return
            }

            cdSaying.title = saying.title
            cdSaying.meaning = saying.meaning
            cdSaying.liked = saying.liked

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to update saying: \(error)")
            }
        }
    }

    private func fetchCd(by id: Int) -> CDSaying? {
        let request: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        request.predicate = NSPredicate(format: "rid == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCd(by id: Int) -> CDSaying {
        if let existing = fetchCd(by: id) {
            return existing
        } else {
            let new = CDSaying(context: context)
            new.rid = Int32(id)
            return new
        }
    }
    
    func deleteAllSayings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSaying.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All sayings deleted successfully")
        } catch {
            print("❌ Failed to delete sayings: \(error)")
        }
    }

}
