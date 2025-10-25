//
//  SharedWidgetManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//
//
//import Foundation
//
//public final class SharedDataManager {
//    public static let shared = SharedDataManager()
//    
//    private let userDefaults: UserDefaults
//    private let wordsKey = "shared_words_data"
//    private let currentWordKey = "shared_current_word"
//    
//    #if DEBUG
//    private let appGroup = "group.com.swahilib.stg.widget"
//    #else
//    private let appGroup = "group.com.swahilib.widget"
//    #endif
//    
//    private init() {
//        // Use app group for sharing data between app and widget
//        self.userDefaults = UserDefaults(suiteName: appGroup)
//    }
//    
//    // MARK: - Save Data
//    public func saveAllWords(_ words: [Word]) {
//        do {
//            let encoder = JSONEncoder()
//            let encoded = try encoder.encode(words)
//            userDefaults.set(encoded, forKey: wordsKey)
//            userDefaults.synchronize()
//            
//            // Update current word for widget
//            updateCurrentWord(from: words)
//        } catch {
//            print("Failed to save words: \(error)")
//        }
//    }
//    
//    public func saveCurrentWord(_ word: Word) {
//        do {
//            let encoder = JSONEncoder()
//            let encoded = try encoder.encode(word.widgetData)
//            userDefaults.set(encoded, forKey: currentWordKey)
//            userDefaults.synchronize()
//        } catch {
//            print("Failed to save current word: \(error)")
//        }
//    }
//    
//    // MARK: - Retrieve Data
//    public func getAllWords() -> [Word] {
//        guard let data = userDefaults.data(forKey: wordsKey) else {
//            return []
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode([Word].self, from: data)
//        } catch {
//            print("Failed to decode words: \(error)")
//            return []
//        }
//    }
//    
//    public func getCurrentWord() -> WordWidgetData? {
//        guard let data = userDefaults.data(forKey: currentWordKey) else {
//            return nil
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(WordWidgetData.self, from: data)
//        } catch {
//            print("Failed to decode current word: \(error)")
//            return nil
//        }
//    }
//    
//    // MARK: - Helper Methods
//    private func updateCurrentWord(from words: [Word]) {
//        // Strategy: Use date to determine which word to show
//        let calendar = Calendar.current
//        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
//        
//        if !words.isEmpty {
//            let index = dayOfYear % words.count
//            let currentWord = words[index]
//            saveCurrentWord(currentWord)
//        }
//    }
//    
//    public func refreshCurrentWord() {
//        let words = getAllWords()
//        updateCurrentWord(from: words)
//    }
//    
//    // MARK: - Clear Data
//    public func clearAllData() {
//        userDefaults.removeObject(forKey: wordsKey)
//        userDefaults.removeObject(forKey: currentWordKey)
//        userDefaults.synchronize()
//    }
//}
