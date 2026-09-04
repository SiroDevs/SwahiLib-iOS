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
    func cancelDailyNotifications()
    func handleNotificationTap(_ userInfo: [AnyHashable: Any]) -> Word?
}

class NotificationService: NotificationServiceProtocol {
    private let wordDataManager: WordDataManager
    
    init(wordDataManager: WordDataManager) {
        self.wordDataManager = wordDataManager
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
        content.body = formatNotificationBody(for: todaysWord)
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
    
    func cancelDailyNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["wordOfTheDay"])
        print("🗑️ Daily notifications cancelled")
    }
    
    private func getTodaysWord() -> Word? {
        let allWords = wordDataManager.fetchWords()
        
        guard !allWords.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % allWords.count
        
        return allWords[index]
    }
    
    func handleNotificationTap(_ userInfo: [AnyHashable: Any]) -> Word? {
        if let wordId = userInfo["wordId"] as? Int {
            return wordDataManager.fetchWord(withId: wordId)
        }
        return nil
    }

    private func formatNotificationBody(for word: Word?) -> String {
        guard let word = word else {
            return "Tazama neno la siku ya leo!"
        }
        
        let truncatedMeaning = truncateText(word.meaning, maxLength: 100)
        let formattedSynonyms = !word.synonyms.isEmpty ? "\nVisawe: \(truncateText(word.meaning, maxLength: 20))" : ""
        
        return "\(truncatedMeaning)\(formattedSynonyms)"
    }
    
    private func truncateText(_ text: String, maxLength: Int) -> String {
        guard text.count > maxLength else { return text }
        
        let endIndex = text.index(text.startIndex, offsetBy: maxLength - 3)
        return String(text[..<endIndex]) + "..."
    }
}
