//
//  AppPrefences.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

class PrefsRepository {
    private enum Keys {
        static let isSelected = "dataIsSelectedKey"
        static let isLoaded = "dataIsLoadedKey"
        static let selectedBooks = "selectedBooksKey"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isDataSelected: Bool {
        get {
            return userDefaults.bool(forKey: Keys.isSelected)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isSelected)
        }
    }
    
    var isDataLoaded: Bool {
        get {
            return userDefaults.bool(forKey: Keys.isLoaded)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isLoaded)
        }
    }
    
    var selectedBooks: String {
        get {
            return userDefaults.string(forKey: Keys.selectedBooks) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Keys.selectedBooks)
        }
    }
}
