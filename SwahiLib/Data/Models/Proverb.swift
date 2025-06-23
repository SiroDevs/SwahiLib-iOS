//
//  Proverb.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Proverb: Identifiable, Codable {
    var id: Int = 0
    let rid: Int
    let title: String?
    let synonyms: String?
    let meaning: String?
    let conjugation: String?
    let views: Int
    let likes: Int
    let liked: Bool = false
    let createdAt: String?
    let updatedAt: String?
    var identity: Int { rid }
    
    enum CodingKeys: String, CodingKey {
        case rid
        case title
        case synonyms
        case meaning
        case conjugation
        case views
        case likes
        case createdAt
        case updatedAt
    }
}
