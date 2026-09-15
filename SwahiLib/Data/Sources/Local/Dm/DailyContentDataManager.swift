//
//  DailyContentDataManager.swift
//  SwahiLib
//
//  Mirrors Android's DailyContentManager + DailyContentDao: one persisted
//  row per calendar day holding that day's word + proverb pick, created
//  once (idempotent by date) and re-read on every later visit so the
//  Daily Word/Proverb screens and the notification always agree, and so
//  past days build up into a history.
//

import CoreData

class DailyContentDataManager {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }

    private static var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: Date())
    }

    /// Returns today's daily content, creating it (from a random word +
    /// random proverb) the first time it's asked for on a given day.
    func getOrCreateToday(words: [Word], proverbs: [Proverb]) -> DailyContent {
        let today = Self.todayKey

        if let existing = fetch(date: today) {
            return existing
        }

        let word = words.randomElement()
        let proverb = proverbs.randomElement()

        let fresh = DailyContent(
            date: today,
            wordRid: word?.rid ?? 0,
            wordMeaning: pickRandomMeaning(word?.meaning, delimiters: ["|"]),
            proverbRid: proverb?.rid ?? 0,
            proverbMeaning: pickRandomMeaning(proverb?.meaning, delimiters: ["|", "#"])
        )

        save(fresh)
        return fetch(date: today) ?? fresh
    }

    func fetch(date: String) -> DailyContent? {
        let fetchRequest: NSFetchRequest<CDDailyContent> = CDDailyContent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        fetchRequest.fetchLimit = 1

        do {
            guard let cd = try context.fetch(fetchRequest).first else { return nil }
            return map(cd)
        } catch {
            print("Failed to fetch daily content: \(error)")
            return nil
        }
    }

    func fetchAll() -> [DailyContent] {
        let fetchRequest: NSFetchRequest<CDDailyContent> = CDDailyContent.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try context.fetch(fetchRequest).map(map)
        } catch {
            print("Failed to fetch daily content history: \(error)")
            return []
        }
    }

    func clearAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDDailyContent.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All daily content deleted successfully")
        } catch {
            print("❌ Failed to delete daily content: \(error)")
        }
    }

    private func save(_ content: DailyContent) {
        context.performAndWait {
            let cd = CDDailyContent(context: self.context)
            cd.date = content.date
            cd.wordRid = Int32(content.wordRid)
            cd.wordMeaning = content.wordMeaning
            cd.proverbRid = Int32(content.proverbRid)
            cd.proverbMeaning = content.proverbMeaning

            do {
                try self.context.save()
            } catch {
                print("Failed to save daily content: \(error)")
            }
        }
    }

    private func map(_ cd: CDDailyContent) -> DailyContent {
        DailyContent(
            date: cd.date ?? "",
            wordRid: Int(cd.wordRid),
            wordMeaning: cd.wordMeaning ?? "",
            proverbRid: Int(cd.proverbRid),
            proverbMeaning: cd.proverbMeaning ?? ""
        )
    }

    private func pickRandomMeaning(_ meaning: String?, delimiters: [String]) -> String {
        guard let meaning else { return "" }
        var parts = [meaning]
        for delimiter in delimiters {
            parts = parts.flatMap { $0.components(separatedBy: delimiter) }
        }
        let candidates = parts
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return candidates.randomElement() ?? ""
    }
}
