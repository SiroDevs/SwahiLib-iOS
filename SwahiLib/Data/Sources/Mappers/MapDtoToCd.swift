//
//  MapDtoToCd.swift
//  SwahiLib
//
//  Created by @sirodevs on 17/12/2025.
//

struct MapDtoToCd {
    static func mapToCd(_ dto: IdiomDTO, _ cd: CDIdiom) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
        cd.views = Int32(dto.views ?? 0)
        cd.likes = Int32(dto.likes ?? 0)
        cd.liked = false
        cd.createdAt = dto.createdAt
        cd.updatedAt = dto.updatedAt
    }

    static func mapToCd(_ dto: ProverbDTO, _ cd: CDProverb) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.synonyms = dto.synonyms
        cd.meaning = dto.meaning
        cd.conjugation = dto.conjugation
        cd.views = Int32(dto.views ?? 0)
        cd.likes = Int32(dto.likes ?? 0)
        cd.liked = false
        cd.createdAt = dto.createdAt
        cd.updatedAt = dto.updatedAt
    }

    static func mapToCd(_ dto: SayingDTO, _ cd: CDSaying) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
        cd.views = Int32(dto.views ?? 0)
        cd.likes = Int32(dto.likes ?? 0)
        cd.liked = false
        cd.createdAt = dto.createdAt
        cd.updatedAt = dto.updatedAt
    }
    
    static func mapToCd(_ dto: WordDTO, _ cd: CDWord) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
        cd.conjugation = dto.conjugation
        cd.synonyms = dto.synonyms
        cd.views = Int32(dto.views ?? 0)
        cd.likes = Int32(dto.likes ?? 0)
        cd.liked = false
        cd.createdAt = dto.createdAt
        cd.updatedAt = dto.updatedAt
    }
}
