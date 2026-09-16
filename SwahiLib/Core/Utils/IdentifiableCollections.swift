//
//  IdentifiableCollections.swift
//  SwahiLib
//
//  Dictionary(uniqueKeysWithValues:) traps at runtime the moment two items
//  share a key. The idiom/proverb/saying tables have had duplicate `rid`
//  rows before (see the LazyVStack gap bug fixed earlier), and nothing
//  guarantees they won't again after a bad sync - so anywhere we build a
//  "keyed by id" lookup from fetched content, use this instead. On a
//  collision it keeps the first item and drops the rest, rather than
//  crashing the screen that was just trying to show history.
//

import Foundation

extension Sequence {
    func keyedByID<ID: Hashable, Value>(
        _ keyValue: (Element) -> (ID, Value)
    ) -> [ID: Value] {
        Dictionary(map(keyValue), uniquingKeysWith: { first, _ in first })
    }
}
