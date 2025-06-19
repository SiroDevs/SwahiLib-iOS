//
//  Saying.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Saying: Identifiable, Codable {
    var id: Int
    let rid: Int
    let title: String
    let meaning: String
    let views: Int
    let likes: Int
    let liked: Bool
    let createdAt: String
    let updatedAt: String
}
