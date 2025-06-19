//
//  Book.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Book: Identifiable, Codable, Equatable {
    var id: Int { bookId }
    let bookId: Int
    let title: String
    let subTitle: String
    let songs: Int
    let position: Int
    let bookNo: Int
    let enabled: Bool
    let created: String
}
