//
//  NotificationService.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UserNotifications

protocol NotificationServiceProtocol {
    func checkNotificationPermission()
    func scheduleDailyWordNotification(at hour: Int, minute: Int)
    func scheduleDailyProverbNotification(at hour: Int, minute: Int)
    func cancelDailyNotifications()
    func handleNotificationTap(_ userInfo: [AnyHashable: Any]) -> Word?
    func handleProverbNotificationTap(_ userInfo: [AnyHashable: Any]) -> Proverb?
}

class NotificationService: NotificationServiceProtocol {
    private let wordDataManager: WordDataManager
    private let proverbDataManager: ProverbDataManager
    private let dailyContentData: DailyContentDataManager

    init(
        wordDataManager: WordDataManager,
        proverbDataManager: ProverbDataManager,
        dailyContentData: DailyContentDataManager
    ) {
        self.wordDataManager = wordDataManager
        self.proverbDataManager = proverbDataManager
        self.dailyContentData = dailyContentData
    }
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyWordNotification(at hour: Int = 6, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: ["wordOfTheDay"])
        
        let todaysWord = getTodaysWord()
        
        let content = UNMutableNotificationContent()
        
        let truncatedTitle = truncateText(todaysWord?.title ?? "", maxLength: 20)
        
        content.title = "📖 Neno la Siku: \(truncatedTitle)"
        content.body = formatWordNotificationBody(for: todaysWord)
        content.sound = .default
        content.userInfo = ["wordId": todaysWord?.rid ?? 0]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "wordOfTheDay",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func scheduleDailyProverbNotification(at hour: Int = 6, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers: ["proverbOfTheDay"])

        let todaysProverb = getTodaysProverb()

        let content = UNMutableNotificationContent()

        let truncatedTitle = truncateText(todaysProverb?.title ?? "", maxLength: 20)

        content.title = "📜 Methali ya Siku: \(truncatedTitle)"
        content.body = formatProverbNotificationBody(for: todaysProverb)
        content.sound = .default
        content.userInfo = ["proverbId": todaysProverb?.rid ?? 0]

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "proverbOfTheDay",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelDailyNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["wordOfTheDay", "proverbOfTheDay"]
        )
        print("🗑️ Daily notifications cancelled")
    }
    
    /// Sourced from the same persisted daily-content row the Daily Word
    /// screen reads, so the notification and the screen always agree —
    /// previously this picked a word deterministically from the day of
    /// year without persisting anything, which could drift once a real
    /// Daily Word screen existed.
    private func getTodaysWord() -> Word? {
        let words = wordDataManager.fetchWords()
        let proverbs = proverbDataManager.fetchProverbs()
        guard !words.isEmpty else { return nil }

        let today = dailyContentData.getOrCreateToday(words: words, proverbs: proverbs)
        return words.first { $0.rid == today.wordRid }
    }

    private func getTodaysProverb() -> Proverb? {
        let words = wordDataManager.fetchWords()
        let proverbs = proverbDataManager.fetchProverbs()
        guard !proverbs.isEmpty else { return nil }

        let today = dailyContentData.getOrCreateToday(words: words, proverbs: proverbs)
        return proverbs.first { $0.rid == today.proverbRid }
    }
    
    func handleNotificationTap(_ userInfo: [AnyHashable: Any]) -> Word? {
        if let wordId = userInfo["wordId"] as? Int {
            return wordDataManager.fetchWord(withId: wordId)
        }
        return nil
    }

    func handleProverbNotificationTap(_ userInfo: [AnyHashable: Any]) -> Proverb? {
        if let proverbId = userInfo["proverbId"] as? Int {
            return proverbDataManager.fetchProverb(withId: proverbId)
        }
        return nil
    }

    private func formatWordNotificationBody(for word: Word?) -> String {
        guard let word = word else {
            return "Tazama neno la siku ya leo!"
        }
        
        let truncatedMeaning = truncateText(word.meaning, maxLength: 100)
        let formattedSynonyms = !word.synonyms.isEmpty ? "\nVisawe: \(truncateText(word.meaning, maxLength: 20))" : ""
        
        return "\(truncatedMeaning)\(formattedSynonyms)"
    }

    private func formatProverbNotificationBody(for proverb: Proverb?) -> String {
        guard let proverb = proverb else {
            return "Tazama methali ya siku ya leo!"
        }

        return truncateText(proverb.meaning, maxLength: 120)
    }
    
    private func truncateText(_ text: String, maxLength: Int) -> String {
        guard text.count > maxLength else { return text }
        
        let endIndex = text.index(text.startIndex, offsetBy: maxLength - 3)
        return String(text[..<endIndex]) + "..."
    }
}
