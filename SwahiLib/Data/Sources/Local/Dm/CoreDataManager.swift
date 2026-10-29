//
//  CoreDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 29/04/2025.
//
//  Owns the Core Data stack. The persistent store is loaded once and awaited by
//  every caller. All sync writes run on a single shared background context, so
//  they are serialized and never touch managed objects from the wrong queue.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer
    private let syncContext: NSManagedObjectContext

    private var loadTask: Task<Void, Error>?
    private let loadTaskLock = NSLock()

    private init() {
        let container = NSPersistentContainer(name: "SwahiLib")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        persistentContainer = container
        syncContext = backgroundContext
    }

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // Waits for the persistent store to finish loading; safe to call from anywhere, any number of times.
    func ensureLoaded() async throws {
        try await sharedLoadTask().value
    }

    // Runs the work on the shared sync context and saves; the context is reset afterwards to free memory.
    func performSyncWrite(_ work: @escaping (NSManagedObjectContext) throws -> Void) async throws {
        try await ensureLoaded()
        let context = syncContext

        try await context.perform { () throws -> Void in
            defer { context.reset() }
            try work(context)
            if context.hasChanges {
                try context.save()
            }
        }
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    // Creates the single store-loading task under a lock so concurrent callers share it.
    private func sharedLoadTask() -> Task<Void, Error> {
        loadTaskLock.lock()
        defer { loadTaskLock.unlock() }

        if let loadTask { return loadTask }

        let newTask = Task { try await self.loadStores() }
        loadTask = newTask
        return newTask
    }

    private func loadStores() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            persistentContainer.loadPersistentStores { description, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                print("📦 Core Data SQLite DB path:\n\(description.url?.path ?? "unknown")")
                continuation.resume()
            }
        }
    }
}
