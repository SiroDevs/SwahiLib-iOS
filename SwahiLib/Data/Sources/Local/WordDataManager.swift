//
//  WordDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class WordDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }
    
    func saveWords(_ words: [Word]) {
        context.perform {
            do {
                for word in words {
                    let cdWord = self.findOrCreateCd(by: word.rid)
                    MapEntityToCd.mapToCd(word, cdWord)
                }
                try self.context.save()
                print("✅ Words saved successfully")
            } catch {
                print("❌ Failed to save words: \(error)")
            }
        }
    }
    
    func saveWord(_ word: Word) {
        context.perform {
            do {
                let cdWord = self.findOrCreateCd(by: word.rid)
                MapEntityToCd.mapToCd(word, cdWord)
                try self.context.save()
            } catch {
                print("❌ Failed to save word: \(error)")
            }
        }
    }
    
    func fetchWords() -> [Word] {
        let request: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch words: \(error)")
            return []
        }
    }
    
    func getWordsByTitles(titles: [String]) -> [Word] {
        let request: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        request.predicate = NSPredicate(format: "title IN %@", titles)
        do {
            return try context.fetch(request).map(MapCdToEntity.mapToEntity(_:))
        } catch {
            print("❌ Failed to fetch words: \(error)")
            return []
        }
    }

    func fetchWord(withId id: Int) -> Word? {
        fetchCd(by: id).map(MapCdToEntity.mapToEntity(_:))
    }

    func updateWord(_ word: Word) {
        context.perform {
            guard let cdWord = self.fetchCd(by: word.id) else {
                print("⚠️ Word with ID \(word.id) not found.")
                return
            }

            cdWord.title = word.title
            cdWord.meaning = word.meaning
            cdWord.liked = word.liked

            do {
                try self.context.save()
            } catch {
                print("❌ Failed to update word: \(error)")
            }
        }
    }

    private func fetchCd(by id: Int) -> CDWord? {
        let request: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        request.predicate = NSPredicate(format: "rid == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCd(by id: Int) -> CDWord {
        if let existing = fetchCd(by: id) {
            return existing
        } else {
            let new = CDWord(context: context)
            new.rid = Int32(id)
            return new
        }
    }
    
    func deleteAllWords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDWord.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All words deleted successfully")
        } catch {
            print("❌ Failed to delete words: \(error)")
        }
    }

}
