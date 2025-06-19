//
//  Selectable.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Selectable<T>: Identifiable {
    let id = UUID()
    var data: T
    var isSelected: Bool
}

enum ViewUiState: Equatable {
    case idle
    case loading(String? = nil)
    case saving(String? = nil)
    case synced
    case filtering
    case filtered
    case fetched
    case saved
    case loaded
    case liked
    case error(String)
}
