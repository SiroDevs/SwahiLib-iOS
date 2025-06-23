//
//  UiState.swift
//  SwahiLib
//
//  Created by Siro Daves on 23/06/2025.
//

enum UiState: Equatable {
    case idle
    case loading
    case loaded
    case filtered
    case saving
    case saved
    case error(String)
}
