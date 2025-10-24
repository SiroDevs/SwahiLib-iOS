//
//  MapEntityToDto.swift
//  SwahiLib
//
//  Created by @sirodevs on 03/07/2025.
//

struct MapEntityToDto {
    static func mapToDto(_ entity: Idiom) -> IdiomDTO {
        IdiomDTO(
            rid: entity.rid,
            title: entity.title,
            meaning: entity.meaning,
            views: entity.views,
            likes: entity.likes,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func mapToDto(_ entity: Proverb) -> ProverbDTO {
        ProverbDTO(
            rid: entity.rid,
            title: entity.title,
            synonyms: entity.synonyms,
            meaning: entity.meaning,
            conjugation: entity.conjugation,
            views: entity.views,
            likes: entity.likes,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func mapToDto(_ entity: Saying) -> SayingDTO {
        SayingDTO(
            rid: entity.rid,
            title: entity.title,
            meaning: entity.meaning,
            views: entity.views,
            likes: entity.likes,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    static func mapToDto(_ entity: Word) -> WordDTO {
        WordDTO(
            rid: entity.rid,
            title: entity.title,
            synonyms: entity.synonyms,
            meaning: entity.meaning,
            conjugation: entity.conjugation,
            views: entity.views,
            likes: entity.likes,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
