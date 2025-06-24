//
//  Word.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Word: Identifiable, Codable {
    var id: Int { rid }
    let rid: Int
    let title: String?
    let synonyms: String?
    let meaning: String?
    let conjugation: String?
    let views: Int
    let likes: Int
    var liked: Bool = false
    let createdAt: String?
    let updatedAt: String?
    var identity: Int { rid }
}
