//
//  WordDTO.swift
//  SwahiLib
//
//  Created by Siro Daves on 24/06/2025.
//

struct WordDTO: Codable {
    let rid: Int
    let title: String?
    let synonyms: String?
    let meaning: String?
    let conjugation: String?
    let views: Int?
    let likes: Int?
    let createdAt: String?
    let updatedAt: String?
}
