//
//  SongDataManager.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import CoreData

class SongDataManager {
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
    func saveSongs(_ songs: [Song]) {
        context.perform {
            do {
                for song in songs {
                    let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "songId == %d", song.songId)
                    fetchRequest.fetchLimit = 1

                    let existingRecords = try self.context.fetch(fetchRequest)
                    let cdSong: CDSong

                    if let existingRecord = existingRecords.first {
                        cdSong = existingRecord
                    } else {
                        cdSong = CDSong(context: self.context)
                    }

                    // Safely set values
                    cdSong.songId = Int32(song.songId)
                    cdSong.book = Int32(song.book)
                    cdSong.songNo = Int32(song.songNo)
                    cdSong.title = song.title
                    cdSong.alias = song.alias
                    cdSong.content = song.content
                    cdSong.views = Int32(song.views)
                    cdSong.likes = Int32(song.likes)
                    cdSong.liked = song.liked
                    cdSong.created = song.created
                }

                try self.context.save()
            } catch {
                print("Failed to save songs: \(error)")
            }
        }
    }
    
    // Fetch all songs or songs for a specific book
    func fetchSongs() -> [Song] {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()        
        do {
            let cdSongs = try context.fetch(fetchRequest)
            return cdSongs.map { cdSong in
                return Song(
                    book: Int(cdSong.book),
                    songId: Int(cdSong.songId),
                    songNo: Int(cdSong.songNo),
                    title: cdSong.title ?? "",
                    alias: cdSong.alias ?? "",
                    content: cdSong.content ?? "",
                    views: Int(cdSong.views),
                    likes: Int(cdSong.likes),
                    liked: cdSong.liked,
                    created: cdSong.created ?? "",
                )
            }
        } catch {
            print("Failed to fetch songs: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchSong(withId id: Int) -> Song? {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songId == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSong = results.first else { return nil }
            
            return Song(
                book: Int(cdSong.book),
                songId: Int(cdSong.songId),
                songNo: Int(cdSong.songNo),
                title: cdSong.title ?? "",
                alias: cdSong.alias ?? "",
                content: cdSong.content ?? "",
                views: Int(cdSong.views),
                likes: Int(cdSong.likes),
                liked: cdSong.liked,
                created: cdSong.created ?? "",
            )
        } catch {
            print("Failed to fetch song: \(error)")
            return nil
        }
    }
    
    func updateSong(_ song: Song) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "songId == %d", song.songId)
            fetchRequest.fetchLimit = 1
            
            do {
                if let cdSong = try self.context.fetch(fetchRequest).first {
                    cdSong.title = song.title
                    cdSong.alias = song.alias
                    cdSong.content = song.content
                    cdSong.liked = song.liked
                    
                    try self.context.save()
                } else {
                    print("Song with ID \(song.songId) not found.")
                }
            } catch {
                print("Failed to update song: \(error)")
            }
        }
    }

    func deleteSong(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSong> = CDSong.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let songToDelete = results.first {
                context.delete(songToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete song: \(error)")
        }
    }
}
