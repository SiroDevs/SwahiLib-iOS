//
//  SayingDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class SayingDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    func saveSayings(_ sayings: [Saying]) {
        context.perform {
            do {
                for saying in sayings {
                    let cdSaying = self.findOrCreateCDSaying(by: saying.id)
                    self.mapSayingToCDSaying(saying, cdSaying)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to save sayings: \(error)")
            }
        }
    }

    func fetchSayings() -> [Saying] {
        let request: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        do {
            return try context.fetch(request).map(self.mapCDSayingToSaying(_:))
        } catch {
            print("❌ Failed to fetch sayings: \(error)")
            return []
        }
    }

    func fetchSaying(withId id: Int) -> Saying? {
        fetchCDSaying(by: id).map(mapCDSayingToSaying(_:))
    }

    func updateSaying(_ saying: Saying) {
        context.perform {
            guard let cdSaying = self.fetchCDSaying(by: saying.id) else {
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

    func deleteSaying(withId id: Int) {
        guard let sayingToDelete = fetchCDSaying(by: id) else { return }

        context.delete(sayingToDelete)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete saying: \(error)")
        }
    }

    private func fetchCDSaying(by id: Int) -> CDSaying? {
        let request: NSFetchRequest<CDSaying> = CDSaying.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCDSaying(by id: Int) -> CDSaying {
        if let existing = fetchCDSaying(by: id) {
            return existing
        } else {
            let new = CDSaying(context: context)
            new.rid = Int32(id)
            return new
        }
    }

    private func mapCDSayingToSaying(_ cd: CDSaying) -> Saying {
        Saying(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            meaning: cd.meaning ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }

    private func mapSayingToCDSaying(_ saying: Saying, _ cd: CDSaying) {
        cd.rid = Int32(saying.rid)
        cd.title = saying.title
        cd.meaning = saying.meaning
        cd.views = Int32(saying.views)
        cd.likes = Int32(saying.likes)
        cd.liked = saying.liked
        cd.createdAt = saying.createdAt
        cd.updatedAt = saying.updatedAt
    }
}
