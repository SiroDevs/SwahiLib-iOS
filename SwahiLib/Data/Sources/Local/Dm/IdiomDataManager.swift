//
//  IdiomDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//

import CoreData

class IdiomDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    // Inserts or updates every idiom on the shared sync context.
    func upsertIdioms(_ idiomDTOs: [IdiomDTO]) async throws {
        try await coreDataManager.performSyncWrite { syncContext in
            try CoreDataUpsert.upsert(idiomDTOs, into: syncContext, entityType: CDIdiom.self, remoteId: { $0.rid }) {
                MapDtoToCd.mapToCd($0, $1)
            }
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
