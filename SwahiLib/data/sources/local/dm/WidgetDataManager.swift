//
//  WidgetDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import Foundation

class WidgetDataManager {
    static let shared = WidgetDataManager()
    
#if DEBUG
    private let appGroup = "group.com.swahilib.stg.widget"
#else
    private let appGroup = "group.com.swahilib.widget"
#endif
    
    func saveRandomWord(_ word: Word) {
        guard let sharedDefaults = UserDefaults(suiteName: appGroup) else { return }
        
        let wordData: [String: Any] = [
            "title": word.title,
            "meaning": word.meaning,
            "synonyms": word.synonyms,
            "conjugation": word.conjugation,
            "savedDate": Date().timeIntervalSince1970
        ]
        
        sharedDefaults.set(wordData, forKey: "currentWord")
    }
    
    func getCurrentWord() -> (title: String, meaning: String, synonyms: String, conjugation: String)? {
        guard let sharedDefaults = UserDefaults(suiteName: appGroup),
              let wordData = sharedDefaults.dictionary(forKey: "currentWord"),
              let title = wordData["title"] as? String,
              let meaning = wordData["meaning"] as? String,
              let synonyms = wordData["synonyms"] as? String,
              let conjugation = wordData["conjugation"] as? String else {
            return nil
        }
        
        return (title, meaning, synonyms, conjugation)
    }
    
    func shouldUpdateWord() -> Bool {
        guard let sharedDefaults = UserDefaults(suiteName: appGroup),
              let wordData = sharedDefaults.dictionary(forKey: "currentWord"),
              let savedDate = wordData["savedDate"] as? TimeInterval else {
            return true
        }
        
        let lastUpdate = Date(timeIntervalSince1970: savedDate)
        let calendar = Calendar.current
        return !calendar.isDateInToday(lastUpdate)
    }
}
