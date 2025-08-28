//
//  AppPrefences.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

class PrefsRepository {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isUserAKid: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isUserAKid) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isUserAKid) }
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isLoaded) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isLoaded) }
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: PrefConstants.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: PrefConstants.installDate) }
    }
    
    var reviewRequested: Bool {
        get { userDefaults.bool(forKey: PrefConstants.reviewRequested) }
        set { userDefaults.set(newValue, forKey: PrefConstants.reviewRequested) }
    }
    
    var lastReviewPrompt: Date {
        get { userDefaults.object(forKey: PrefConstants.lastReviewPrompt) as? Date ?? .distantPast }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastReviewPrompt) }
    }
    
    var usageTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.usageTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.usageTime) }
    }
    
    func resetPrefs() {
        installDate = Date()
        lastReviewPrompt = .distantPast
        isUserAKid = false
        isDataLoaded = false
        reviewRequested = false
    }
}
