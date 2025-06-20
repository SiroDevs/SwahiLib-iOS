//
//  WordDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class WordDataManager {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveWords(_ words: [Word]) {
        context.perform {
            do {
                for word in words {
                    let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "wordId == %d", word.id)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdWord: CDWord

                    if let existingRecord = existingRecords.first {
                        cdWord = existingRecord
                    } else {
                        cdWord = CDWord(context: self.context)
                    }

                    // Safely set values
                    cdWord.id = Int32(word.id)
                    cdWord.rid = Int32(word.rid)
                    cdWord.title = word.title
                    cdWord.synonyms = word.synonyms
                    cdWord.meaning = word.meaning
                    cdWord.conjugation = word.conjugation
                    cdWord.views = Int32(word.views)
                    cdWord.likes = Int32(word.likes)
                    cdWord.liked = word.liked
                    cdWord.createdAt = word.createdAt
                    cdWord.updatedAt = word.updatedAt
                }

                try self.context.save()
            } catch {
                print("Failed to save words: \(error)")
            }
        }
    }
    
    // Fetch all words or words for a specific book
    func fetchWords() -> [Word] {
        let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()        
        do {
            let cdWords = try context.fetch(fetchRequest)
            return cdWords.map { cdWord in
                return Word(
                    id: Int(cdWord.id),
                    rid: Int(cdWord.rid),
                    title: cdWord.title ?? "",
                    synonyms: cdWord.synonyms ?? "",
                    meaning: cdWord.meaning ?? "",
                    conjugation: cdWord.conjugation ?? "",
                    views: Int(cdWord.views),
                    likes: Int(cdWord.likes),
                    liked: cdWord.liked,
                    createdAt: cdWord.createdAt ?? "",
                    updatedAt: cdWord.updatedAt ?? "",
                )
            }
        } catch {
            print("Failed to fetch words: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchWord(withId id: Int) -> Word? {
        let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wordId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdWord = results.first else { return nil }
            
            return Word(
                id: Int(cdWord.id),
                rid: Int(cdWord.rid),
                title: cdWord.title ?? "",
                synonyms: cdWord.synonyms ?? "",
                meaning: cdWord.meaning ?? "",
                conjugation: cdWord.conjugation ?? "",
                views: Int(cdWord.views),
                likes: Int(cdWord.likes),
                liked: cdWord.liked,
                createdAt: cdWord.createdAt ?? "",
                updatedAt: cdWord.updatedAt ?? "",
            )
        } catch {
            print("Failed to fetch word: \(error)")
            return nil
        }
    }
    
    func updateWord(_ word: Word) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "wordId == %d", word.id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdWord = try self.context.fetch(fetchRequest).first {
                    cdWord.title = word.title
                    cdWord.meaning = word.meaning
                    cdWord.conjugation = word.conjugation
                    cdWord.synonyms = word.synonyms
                    cdWord.liked = word.liked
                    
                    try self.context.save()
                } else {
                    print("Word with ID \(word.id) not found.")
                }
            } catch {
                print("Failed to update word: \(error)")
            }
        }
    }

    func deleteWord(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wordId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let wordToDelete = results.first {
                context.delete(wordToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete word: \(error)")
        }
    }
}
