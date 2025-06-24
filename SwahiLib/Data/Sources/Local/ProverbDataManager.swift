//
//  ProverbDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class ProverbDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    func saveProverbs(_ proverbs: [Proverb]) {
        context.perform {
            do {
                for proverb in proverbs {
                    let cdProverb = self.findOrCreateCDProverb(by: proverb.id)
                    self.mapProverbToCDProverb(proverb, cdProverb)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to save proverbs: \(error)")
            }
        }
    }

    func fetchProverbs() -> [Proverb] {
        let request: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        do {
            return try context.fetch(request).map(self.mapCDProverbToProverb(_:))
        } catch {
            print("❌ Failed to fetch proverbs: \(error)")
            return []
        }
    }

    func fetchProverb(withId id: Int) -> Proverb? {
        fetchCDProverb(by: id).map(mapCDProverbToProverb(_:))
    }

    func updateProverb(_ proverb: Proverb) {
        context.perform {
            guard let cdProverb = self.fetchCDProverb(by: proverb.id) else {
                print("⚠️ Proverb with ID \(proverb.id) not found.")
                return
            }

            cdProverb.title = proverb.title
            cdProverb.meaning = proverb.meaning
            cdProverb.liked = proverb.liked

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to update proverb: \(error)")
            }
        }
    }

    func deleteProverb(withId id: Int) {
        guard let proverbToDelete = fetchCDProverb(by: id) else { return }

        context.delete(proverbToDelete)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete proverb: \(error)")
        }
    }

    private func fetchCDProverb(by id: Int) -> CDProverb? {
        let request: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCDProverb(by id: Int) -> CDProverb {
        if let existing = fetchCDProverb(by: id) {
            return existing
        } else {
            let new = CDProverb(context: context)
            new.rid = Int32(id)
            return new
        }
    }

    private func mapCDProverbToProverb(_ cd: CDProverb) -> Proverb {
        Proverb(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            synonyms: cd.synonyms ?? "",
            meaning: cd.meaning ?? "",
            conjugation: cd.conjugation ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }

    private func mapProverbToCDProverb(_ proverb: Proverb, _ cd: CDProverb) {
        cd.rid = Int32(proverb.rid)
        cd.title = proverb.title
        cd.synonyms = proverb.synonyms
        cd.meaning = proverb.meaning
        cd.conjugation = proverb.conjugation
        cd.views = Int32(proverb.views)
        cd.likes = Int32(proverb.likes)
        cd.liked = proverb.liked
        cd.createdAt = proverb.createdAt
        cd.updatedAt = proverb.updatedAt
    }
}
