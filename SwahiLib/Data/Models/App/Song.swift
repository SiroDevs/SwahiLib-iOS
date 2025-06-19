//
//  Song.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Song: Identifiable, Codable {
    var id: Int { songId }
    let book: Int
    let songId: Int
    let songNo: Int
    let title: String
    let alias: String
    let content: String
    let views: Int
    let likes: Int
    let liked: Bool
    let created: String
}
