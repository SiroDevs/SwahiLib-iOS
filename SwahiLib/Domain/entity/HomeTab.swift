//
//  HomeTab.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI

enum HomeTab: String, CaseIterable, Identifiable {
    case all
    case words
    case idioms
    case sayings
    case proverbs

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .all: return "yote"
        case .words: return "maneno"
        case .idioms: return "nahau"
        case .proverbs: return "methali"
        case .sayings: return "misemo"
        }
    }
}

let homeTabs: [HomeTab] = [
    .words,
    .idioms,
    .proverbs,
    .sayings
]
let advancedSearchTypes: [HomeTab] = [.all] + homeTabs
