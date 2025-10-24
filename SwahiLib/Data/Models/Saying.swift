//
//  Saying.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

struct Saying: Identifiable, Codable {
    var id: Int { rid }
    let rid: Int
    let title: String
    let meaning: String
    let views: Int
    let likes: Int
    var liked: Bool
    let createdAt: String
    let updatedAt: String
}
