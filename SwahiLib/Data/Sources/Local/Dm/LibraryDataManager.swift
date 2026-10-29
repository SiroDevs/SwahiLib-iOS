//
//  LibraryDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  All 9 maktaba collections share one Core Data table (CDLibraryItem),
//  scoped by a `collection` column — the iOS equivalent of Android's 9
//  separate Room DAOs, collapsed since every collection already resolves
//  to the same LibraryDisplayItem shape for display.
//

import CoreData

class LibraryDataManager {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    // Deletes everything stored for `collectionKey` and inserts `items` in its place, on the shared sync context.
    func replaceAll(_ items: [LibraryDisplayItem], forCollection collectionKey: String) async throws {
        try await coreDataManager.performSyncWrite { syncContext in
            let existingRequest: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
            existingRequest.predicate = NSPredicate(format: "collection == %@", collectionKey)
            try syncContext.fetch(existingRequest).forEach { syncContext.delete($0) }

            let encoder = JSONEncoder()
            for item in items {
                let libraryItem = CDLibraryItem(context: syncContext)
                libraryItem.collection = collectionKey
                libraryItem.rid = item.id
                libraryItem.groupName = item.groupName
                libraryItem.primaryText = item.primaryText
                libraryItem.secondaryText = item.secondaryText
                libraryItem.orderIndex = Int32(item.orderIndex)
                libraryItem.detailsJson = (try? encoder.encode(item.detailFields))
                    .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
            }
        }
        print("✅ \(items.count) \(collectionKey) library items saved")
    }

    func fetchAll(forCollection collectionKey: String) -> [LibraryDisplayItem] {
        let request: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
        request.predicate = NSPredicate(format: "collection == %@", collectionKey)
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

        do {
            return try context.fetch(request).map { cd in
                let fields: [LibraryDetailField] = cd.detailsJson
                    .flatMap { $0.data(using: .utf8) }
                    .flatMap { try? JSONDecoder().decode([LibraryDetailField].self, from: $0) } ?? []

                return LibraryDisplayItem(
                    id: cd.rid ?? UUID().uuidString,
                    groupName: cd.groupName,
                    primaryText: cd.primaryText ?? "",
                    secondaryText: cd.secondaryText,
                    detailFields: fields,
                    orderIndex: Int(cd.orderIndex)
                )
            }
        } catch {
            print("❌ Failed to fetch library items for \(collectionKey): \(error)")
            return []
        }
    }

    func count(forCollection collectionKey: String) -> Int {
        let request: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
        request.predicate = NSPredicate(format: "collection == %@", collectionKey)
        return (try? context.count(for: request)) ?? 0
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDLibraryItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All library items deleted successfully")
        } catch {
            print("❌ Failed to delete library items: \(error)")
        }
    }
}
