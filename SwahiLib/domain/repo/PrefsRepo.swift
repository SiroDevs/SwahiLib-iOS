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
    
    var shownParentalGate: Bool {
        get { userDefaults.bool(forKey: PrefConstants.shownParentalGate) }
        set { userDefaults.set(newValue, forKey: PrefConstants.shownParentalGate) }
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isLoaded) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isLoaded) }
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: PrefConstants.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: PrefConstants.installDate) }
    }
    
    var lastAppOpenTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.lastAppOpenTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastAppOpenTime) }
    }
    
    func approveShowingPrompt(hours: Int) -> Bool {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return true }
        
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
        isUserAKid = false
        isDataLoaded = false
    }
}
