//
//  HistoryGrouper.swift
//  SwahiLib
//
//  Mirrors Android's feature/history/utils/HistoryUtils.kt: groups rows into
//  day buckets (newest first) and formats a relative timestamp per row.
//  createdAt is stored as a string of epoch milliseconds, matching how
//  HistoryDataManager/SearchDataManager persist it.
//

import Foundation

enum HistoryBucket: String {
    case leo = "Leo"
    case jana = "Jana"
    case wikiHii = "Wiki Hii"
    case mweziHuu = "Mwezi Huu"
    case zamani = "Zamani"
}

enum HistoryRow<T> {
    case header(HistoryBucket)
    case item(T, timestamp: String)
}

enum HistoryGrouper {
    /// "Sasa hivi", "Dakika 3 zilizopita", or a plain "HH:mm" for anything older.
    static func relativeTime(epochMillis: Double) -> String {
        let diffMs = Date().timeIntervalSince1970 * 1000 - epochMillis
        let diffMin = Int(diffMs / 60_000)
        switch true {
        case diffMs < 60_000:
            return "Sasa hivi"
        case diffMin == 1:
            return "Dakika 1 iliyopita"
        case diffMin < 60:
            return "Dakika \(diffMin) zilizopita"
        case diffMin < 120:
            return "Saa 1 iliyopita"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: Date(timeIntervalSince1970: epochMillis / 1000))
        }
    }

    /// Groups `items` into Leo / Jana / Wiki Hii / Mwezi Huu / Zamani buckets,
    /// newest first, with a `.header` row inserted whenever the bucket changes.
    static func group<T>(_ items: [T], epochMillis: (T) -> Double?) -> [HistoryRow<T>] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        func bucket(for ms: Double) -> HistoryBucket {
            let day = calendar.startOfDay(for: Date(timeIntervalSince1970: ms / 1000))
            let daysDiff = calendar.dateComponents([.day], from: day, to: today).day ?? 0
            switch daysDiff {
            case 0: return .leo
            case 1: return .jana
            case 2..<7: return .wikiHii
            case 7..<30: return .mweziHuu
            default: return .zamani
            }
        }

        let sorted = items.sorted { (epochMillis($0) ?? 0) > (epochMillis($1) ?? 0) }
        var rows: [HistoryRow<T>] = []
        var lastBucket: HistoryBucket? = nil

        for item in sorted {
            guard let ms = epochMillis(item) else { continue }
            let b = bucket(for: ms)
            if b != lastBucket {
                rows.append(.header(b))
                lastBucket = b
            }
            rows.append(.item(item, timestamp: relativeTime(epochMillis: ms)))
        }
        return rows
    }
}
