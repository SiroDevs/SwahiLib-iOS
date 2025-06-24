//
//  Idiom.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Idiom: Identifiable, Codable {
    var id: Int { rid }
    let rid: Int
    let title: String
    let meaning: String
    let views: Int
    let likes: Int
    let liked: Bool
    let createdAt: String
    let updatedAt: String
}
