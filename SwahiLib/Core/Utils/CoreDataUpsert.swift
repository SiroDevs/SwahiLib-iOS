//
//  CoreDataUpsert.swift
//  SwahiLib
//
//  Shared helper for syncing remote records into Core Data by their `rid`.
//

import CoreData

protocol RemoteIdentifiable: NSManagedObject {
    var rid: Int32 { get set }
}

extension CDWord: RemoteIdentifiable {}
extension CDIdiom: RemoteIdentifiable {}
extension CDProverb: RemoteIdentifiable {}
extension CDSaying: RemoteIdentifiable {}

enum CoreDataUpsertError: Error {
    case unexpectedEntityType(String)
}

enum CoreDataUpsert {
    // Inserts or updates one object per DTO, matched on rid, using a single fetch for the existing rows.
    // Must be called on the context's own queue (inside performSyncWrite).
    static func upsert<Entity: RemoteIdentifiable, Dto>(
        _ dtos: [Dto],
        into context: NSManagedObjectContext,
        entityType: Entity.Type,
        remoteId: (Dto) -> Int,
        apply: (Dto, Entity) -> Void
    ) throws {
        let entityName = String(describing: entityType)
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.returnsObjectsAsFaults = false

        var entitiesByRid: [Int32: Entity] = [:]
        for existing in try context.fetch(request) where entitiesByRid[existing.rid] == nil {
            entitiesByRid[existing.rid] = existing
        }

        for dto in dtos {
            let rid = Int32(remoteId(dto))

            if let existing = entitiesByRid[rid] {
                apply(dto, existing)
                continue
            }

            guard let created = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Entity else {
                throw CoreDataUpsertError.unexpectedEntityType(entityName)
            }
            apply(dto, created)
            entitiesByRid[rid] = created
        }
    }
}
