//
//  IdiomDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import CoreData

class IdiomDataManager {
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

    func saveIdioms(_ cdIdioms: [CDIdiom]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    for cdIdiom in cdIdioms {
                        let existingCdIdiom = self.findOrCreateCdInContext(context: self.bgContext, by: Int(cdIdiom.rid))
                        
                        existingCdIdiom.rid = cdIdiom.rid
                        existingCdIdiom.title = cdIdiom.title
                        existingCdIdiom.meaning = cdIdiom.meaning
                        existingCdIdiom.views = cdIdiom.views
                        existingCdIdiom.likes = cdIdiom.likes
                        existingCdIdiom.liked = cdIdiom.liked
                        existingCdIdiom.createdAt = cdIdiom.createdAt
                        existingCdIdiom.updatedAt = cdIdiom.updatedAt
                    }
                    
                    try self.bgContext.save()
                    
                    Task { @MainActor in
                        do {
                            try self.context.save()
                            print("✅ \(cdIdioms.count) idioms saved successfully")
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

    private func findOrCreateCdInContext(context: NSManagedObjectContext, by id: Int) -> CDIdiom {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        request.predicate = NSPredicate(format: "rid == %d", id)
        request.fetchLimit = 1
        
        if let existing = try? context.fetch(request).first {
            return existing
        } else {
            let new = CDIdiom(context: context)
            new.rid = Int32(id)
            return new
        }
    }

    func saveIdiom(_ idiom: Idiom) {
        context.perform {
            do {
                let cdIdiom = self.findOrCreateCd(by: idiom.rid)
                MapEntityToCd.mapToCd(idiom, cdIdiom)
                try self.context.save()
            } catch {
                print("❌ Failed to save idiom: \(error)")
            }
        }
    }

    func fetchIdioms() -> [Idiom] {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch idioms: \(error)")
            return []
        }
    }
    
    func getIdiomsByTitles(titles: [String]) -> [Idiom] {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        request.predicate = NSPredicate(format: "title IN %@", titles)
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch idioms: \(error)")
            return []
        }
    }

    func fetchIdiom(withId id: Int) -> Idiom? {
        fetchCd(by: id).map(MapCdToEntity.mapToEntity(_:))
    }

    func updateIdiom(_ idiom: Idiom) {
        context.perform {
            guard let cdIdiom = self.fetchCd(by: idiom.id) else {
                print("⚠️ Idiom with ID \(idiom.id) not found.")
                return
            }

            cdIdiom.title = idiom.title
            cdIdiom.meaning = idiom.meaning
            cdIdiom.liked = idiom.liked

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to update idiom: \(error)")
            }
        }
    }

    private func fetchCd(by id: Int) -> CDIdiom? {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        request.predicate = NSPredicate(format: "rid == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCd(by id: Int) -> CDIdiom {
        if let existing = fetchCd(by: id) {
            return existing
        } else {
            let new = CDIdiom(context: context)
            new.rid = Int32(id)
            return new
        }
    }
    
    func deleteAllIdioms() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDIdiom.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All idioms deleted successfully")
        } catch {
            print("❌ Failed to delete idioms: \(error)")
        }
    }

}
