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
                    let cdWord = self.findOrCreateCDWord(by: word.id)
                    self.mapWordToCDWord(word, cdWord)
                }
                try self.context.save()
            } catch {
                print("❌ Failed to save words: \(error)")
            }
        }
    }

    func fetchWords() -> [Word] {
        let request: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        do {
            return try context.fetch(request).map(self.mapCDWordToWord(_:))
        } catch {
            print("❌ Failed to fetch words: \(error)")
            return []
        }
    }

    func fetchWord(withId id: Int) -> Word? {
        fetchCDWord(by: id).map(mapCDWordToWord(_:))
    }

    func updateWord(_ word: Word) {
        context.perform {
            guard let cdWord = self.fetchCDWord(by: word.id) else {
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

    func deleteWord(withId id: Int) {
        guard let wordToDelete = fetchCDWord(by: id) else { return }

        context.delete(wordToDelete)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete word: \(error)")
        }
    }

    private func fetchCDWord(by id: Int) -> CDWord? {
        let request: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func findOrCreateCDWord(by id: Int) -> CDWord {
        if let existing = fetchCDWord(by: id) {
            return existing
        } else {
            let new = CDWord(context: context)
            new.rid = Int32(id)
            return new
        }
    }

    private func mapCDWordToWord(_ cd: CDWord) -> Word {
        Word(
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

    private func mapWordToCDWord(_ word: Word, _ cd: CDWord) {
        cd.rid = Int32(word.rid)
        cd.title = word.title
        cd.synonyms = word.synonyms
        cd.meaning = word.meaning
        cd.conjugation = word.conjugation
        cd.views = Int32(word.views)
        cd.likes = Int32(word.likes)
        cd.liked = word.liked
        cd.createdAt = word.createdAt
        cd.updatedAt = word.updatedAt
    }
}
