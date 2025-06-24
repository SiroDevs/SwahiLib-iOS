//
//  IdiomDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
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

    func saveIdioms(_ dtos: [IdiomDTO]) {
        context.perform {
            do {
                for dto in dtos {
                    let cdIdiom = self.findOrCreateCDIdiom(by: dto.rid)
                    self.mapDtoToCd(dto, cdIdiom)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to save idioms: \(error)")
            }
        }
    }

    func fetchIdioms() -> [Idiom] {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        do {
            return try context.fetch(request).map(self.mapCDIdiomToIdiom(_:))
        } catch {
            print("❌ Failed to fetch idioms: \(error)")
            return []
        }
    }

    func fetchIdiom(withId id: Int) -> Idiom? {
        fetchCDIdiom(by: id).map(mapCDIdiomToIdiom(_:))
    }

    func updateIdiom(_ idiom: Idiom) {
        context.perform {
            guard let cdIdiom = self.fetchCDIdiom(by: idiom.id) else {
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

    func deleteIdiom(withId id: Int) {
        guard let idiomToDelete = fetchCDIdiom(by: id) else { return }

        context.delete(idiomToDelete)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete idiom: \(error)")
        }
    }

    private func fetchCDIdiom(by id: Int) -> CDIdiom? {
        let request: NSFetchRequest<CDIdiom> = CDIdiom.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCDIdiom(by id: Int) -> CDIdiom {
        if let existing = fetchCDIdiom(by: id) {
            return existing
        } else {
            let new = CDIdiom(context: context)
            new.rid = Int32(id)
            return new
        }
    }

    private func mapCDIdiomToIdiom(_ cd: CDIdiom) -> Idiom {
        Idiom(
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

    private func mapIdiomToCDIdiom(_ idiom: Idiom, _ cd: CDIdiom) {
        cd.rid = Int32(idiom.rid)
        cd.title = idiom.title
        cd.meaning = idiom.meaning
        cd.views = Int32(idiom.views)
        cd.likes = Int32(idiom.likes)
        cd.liked = idiom.liked
        cd.createdAt = idiom.createdAt
        cd.updatedAt = idiom.updatedAt
    }
    
    private func mapDtoToCd(_ dto: IdiomDTO, _ cd: CDIdiom) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
        cd.views = Int32(dto.views ?? 0)
        cd.likes = Int32(dto.likes ?? 0)
        cd.liked = false
        cd.createdAt = dto.createdAt
        cd.updatedAt = dto.updatedAt
    }
}
