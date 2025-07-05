//
//  HomeTab.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

enum HomeTab: String, CaseIterable, Identifiable {
    case words
    case idioms
    case sayings
    case proverbs

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .words: return "maneno"
        case .idioms: return "nahau"
        case .sayings: return "misemo"
        case .proverbs: return "methali"
        }
    }
}

let homeTabs: [HomeTab] = [
    .words,
    .idioms,
    .sayings,
    .proverbs
]
