//
//  History.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct History: Identifiable, Codable {
    var id: Int
    let item: Int
    let type: String
    let createdAt: String
}
