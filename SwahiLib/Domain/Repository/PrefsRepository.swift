//
//  AppPrefences.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

class PrefsRepository {
    private enum Keys {
        static let isLoaded = "dataIsLoadedKey"
        static let installDate = "installDateKey"
        static let reviewRequested = "reviewRequestedKey"
        static let lastReviewPrompt = "lastReviewPromptKey"
        static let usageTime = "usageTimeKey"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: Keys.isLoaded) }
        set { userDefaults.set(newValue, forKey: Keys.isLoaded) }
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: Keys.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: Keys.installDate) }
    }
    
    var reviewRequested: Bool {
        get { userDefaults.bool(forKey: Keys.reviewRequested) }
        set { userDefaults.set(newValue, forKey: Keys.reviewRequested) }
    }
    
    var lastReviewPrompt: Date {
        get { userDefaults.object(forKey: Keys.lastReviewPrompt) as? Date ?? .distantPast }
        set { userDefaults.set(newValue, forKey: Keys.lastReviewPrompt) }
    }
    
    var usageTime: TimeInterval {
        get { userDefaults.double(forKey: Keys.usageTime) }
        set { userDefaults.set(newValue, forKey: Keys.usageTime) }
    }
}
