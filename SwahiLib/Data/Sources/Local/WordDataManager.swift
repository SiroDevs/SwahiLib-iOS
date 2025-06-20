//
//  WordDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class WordDataManager {
    private let coreDataManager: CoreDataManager
    private let bookDataManager: BookDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared,
         bookDataManager: BookDataManager) {
        self.coreDataManager = coreDataManager
        self.bookDataManager = bookDataManager
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
                    fetchRequest.predicate = NSPredicate(format: "wordId == %d", word.wordId)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdWord: CDWord

                    if let existingRecord = existingRecords.first {
                        cdWord = existingRecord
                    } else {
                        cdWord = CDWord(context: self.context)
                    }

                    // Safely set values
                    cdWord.wordId = Int32(word.wordId)
                    cdWord.book = Int32(word.book)
                    cdWord.wordNo = Int32(word.wordNo)
                    cdWord.title = word.title
                    cdWord.alias = word.alias
                    cdWord.content = word.content
                    cdWord.views = Int32(word.views)
                    cdWord.likes = Int32(word.likes)
                    cdWord.liked = word.liked
                    cdWord.created = word.created
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
                    book: Int(cdWord.book),
                    wordId: Int(cdWord.wordId),
                    wordNo: Int(cdWord.wordNo),
                    title: cdWord.title ?? "",
                    alias: cdWord.alias ?? "",
                    content: cdWord.content ?? "",
                    views: Int(cdWord.views),
                    likes: Int(cdWord.likes),
                    liked: cdWord.liked,
                    created: cdWord.created ?? "",
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
                book: Int(cdWord.book),
                wordId: Int(cdWord.wordId),
                wordNo: Int(cdWord.wordNo),
                title: cdWord.title ?? "",
                alias: cdWord.alias ?? "",
                content: cdWord.content ?? "",
                views: Int(cdWord.views),
                likes: Int(cdWord.likes),
                liked: cdWord.liked,
                created: cdWord.created ?? "",
            )
        } catch {
            print("Failed to fetch word: \(error)")
            return nil
        }
    }
    
    func updateWord(_ word: Word) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDWord> = CDWord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "wordId == %d", word.wordId)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdWord = try self.context.fetch(fetchRequest).first {
                    cdWord.title = word.title
                    cdWord.alias = word.alias
                    cdWord.content = word.content
                    cdWord.liked = word.liked
                    
                    try self.context.save()
                } else {
                    print("Word with ID \(word.wordId) not found.")
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
