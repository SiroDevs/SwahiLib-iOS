//
//  BookDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class BookDataManager {
    private let coreDataManager: CoreDataManager
        
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save records to Core Data
    func saveBooks(_ books: [Book]) {
        context.perform {
            do {
                for book in books {
                    let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "bookId == %d", book.bookId)
                    
                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdBook: CDBook
                    
                    if let existingRecord = existingRecords.first {
                        // Update existing record
                        cdBook = existingRecord
                    } else {
                        // Create new record
                        cdBook = CDBook(context: self.context)
                    }
                    
                    // Set all properties
                    cdBook.bookId = Int32(book.bookId)
                    cdBook.title = book.title
                    cdBook.subTitle = book.subTitle
                    cdBook.songs = Int32(book.songs)
                    cdBook.position = Int32(book.position)
                    cdBook.bookNo = Int32(book.bookNo)
                    cdBook.enabled = book.enabled
                    cdBook.created = book.created
                }
                
                try self.context.save()
            } catch {
                print("Failed to save books: \(error)")
            }
        }
    }
    
    // Fetch all records from Core Data
    func fetchBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        do {
            let cdBooks = try context.fetch(fetchRequest)
            return cdBooks.map { cdBook in
                return Book(
                    bookId: Int(cdBook.bookId),
                    title: cdBook.title ?? "",
                    subTitle: cdBook.subTitle ?? "",
                    songs: Int(cdBook.songs),
                    position: Int(cdBook.position),
                    bookNo: Int(cdBook.bookNo),
                    enabled: cdBook.enabled,
                    created: cdBook.created ?? "",
                )
            }
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchBook(withId id: Int) -> Book? {
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdBook = results.first else { return nil }
            
            return Book(
                bookId: Int(cdBook.bookId),
                title: cdBook.title ?? "",
                subTitle: cdBook.subTitle ?? "",
                songs: Int(cdBook.songs),
                position: Int(cdBook.position),
                bookNo: Int(cdBook.bookNo),
                enabled: cdBook.enabled,
                created: cdBook.created ?? "",
            )
        } catch {
            print("Failed to fetch book: \(error)")
            return nil
        }
    }
    
    // Delete a record by ID
    func deleteBook(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let bookToDelete = results.first {
                context.delete(bookToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete book: \(error)")
        }
    }
    
    // Helper method to fetch a record entity by ID (internal use)
    func fetchBookEntity(withId id: Int32) -> CDBook? {
        let fetchRequest: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch book entity: \(error)")
            return nil
        }
    }
}
