//
//  Proverb.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Proverb: Identifiable, Codable {
    var id: Int
    let rid: Int
    let title: String
    let synonyms: String
    let meaning: String
    let conjugation: String
    let views: Int
    let likes: Int
    let liked: Bool
    let createdAt: String
    let updatedAt: String
}
