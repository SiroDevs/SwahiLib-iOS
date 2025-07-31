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
                    let cdProverb = self.findOrCreateCd(by: proverb.rid)
                    MapEntityToCd.mapToCd(proverb, cdProverb)
                }
                try self.context.save()
                print("✅ Proverbs saved successfully")
            } catch {
                print("❌ Failed to save proverbs: \(error)")
            }
        }
    }

    func saveProverb(_ proverb: Proverb) {
        context.perform {
            do {
                let cdProverb = self.findOrCreateCd(by: proverb.rid)
                MapEntityToCd.mapToCd(proverb, cdProverb)
                try self.context.save()
            } catch {
                print("❌ Failed to save proverb: \(error)")
            }
        }
    }

    func fetchProverbs() -> [Proverb] {
        let request: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch proverbs: \(error)")
            return []
        }
    }
    
    func getProverbsByTitles(titles: [String]) -> [Proverb] {
        let request: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        request.predicate = NSPredicate(format: "title IN %@", titles)
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch proverbs: \(error)")
            return []
        }
    }

    func fetchProverb(withId id: Int) -> Proverb? {
        fetchCd(by: id).map(MapCdToEntity.mapToEntity(_:))
    }

    func updateProverb(_ proverb: Proverb) {
        context.perform {
            guard let cdProverb = self.fetchCd(by: proverb.id) else {
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

    private func fetchCd(by id: Int) -> CDProverb? {
        let request: NSFetchRequest<CDProverb> = CDProverb.fetchRequest()
        request.predicate = NSPredicate(format: "rid == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCd(by id: Int) -> CDProverb {
        if let existing = fetchCd(by: id) {
            return existing
        } else {
            let new = CDProverb(context: context)
            new.rid = Int32(id)
            return new
        }
    }
}
