//
//  UiState.swift
//  SwahiLib
//
//  Created by @sirodevs on 23/06/2025.
//

enum UiState: Equatable {
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
