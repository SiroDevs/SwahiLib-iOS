//
//  Responses.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//


struct BookResponse: Decodable {
    let count: Int
    let data: [Book]
}

struct SongResponse: Decodable {
    let count: Int
    let data: [Song]
}
