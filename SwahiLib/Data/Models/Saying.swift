//
//  Saying.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Saying: Identifiable, Codable {
    var id: Int { rid }
    let rid: Int
    let title: String?
    let meaning: String?
    let views: Int
    let likes: Int
    var liked: Bool = false
    let createdAt: String?
    let updatedAt: String?
    var identity: Int { rid }
}
