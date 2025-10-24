//
//  Selectable.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

struct Selectable<T>: Identifiable {
    let id = UUID()
    var data: T
    var isSelected: Bool
}
