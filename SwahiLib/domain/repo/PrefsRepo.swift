//
//  PrefsRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

class PrefsRepo {
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
    
    var isProUser: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isProUser) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isProUser) }
    }
    
    var lastAppOpenTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.lastAppOpenTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastAppOpenTime) }
    }
    
    func hasTimeExceeded(hours: Int) -> Bool {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return false }
        
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - lastTime
        let hoursInSeconds = TimeInterval(hours * 60 * 60)
        
        return timeDifference >= hoursInSeconds
    }
    
    func updateAppOpenTime() {
        lastAppOpenTime = Date().timeIntervalSince1970
    }
    
    func getTimeSinceLastOpen() -> TimeInterval {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return 0 }
        return Date().timeIntervalSince1970 - lastTime
    }
    
    func resetPrefs() {
        installDate = Date()
        lastReviewPrompt = .distantPast
        isUserAKid = false
        isDataLoaded = false
        reviewRequested = false
    }
}
