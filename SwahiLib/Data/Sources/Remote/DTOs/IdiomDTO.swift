//
//  IdiomDTO.swift
//  SwahiLib
//
//  Created by Siro Daves on 24/06/2025.
//

struct IdiomDTO: Codable {
    let rid: Int
    let title: String?
    let meaning: String?
    let views: Int?
    let likes: Int?
    let createdAt: String?
    let updatedAt: String?
}

public func mapDtoToCd(_ dto: IdiomDTO, _ cd: CDIdiom) {
    cd.rid = Int32(dto.rid)
    cd.title = dto.title
    cd.meaning = dto.meaning
    cd.views = Int32(dto.views ?? 0)
    cd.likes = Int32(dto.likes ?? 0)
    cd.liked = false
    cd.createdAt = dto.createdAt
    cd.updatedAt = dto.updatedAt
}
