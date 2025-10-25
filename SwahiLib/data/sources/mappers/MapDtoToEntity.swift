//
//  MapDtoToEntity.swift
//  SwahiLib
//
//  Created by @sirodevs on 03/07/2025.
//

struct MapDtoToEntity {
    static func mapToEntity(_ dto: IdiomDTO) -> Idiom {
        Idiom(
            rid: dto.rid,
            title: dto.title  ?? "",
            meaning: dto.meaning  ?? "",
            views: dto.views ?? 0,
            likes: dto.likes ?? 0,
            liked: false,
            createdAt: dto.createdAt  ?? "",
            updatedAt: dto.updatedAt  ?? ""
        )
    }

    static func mapToEntity(_ dto: ProverbDTO) -> Proverb {
        Proverb(
            rid: dto.rid,
            title: dto.title  ?? "",
            synonyms: dto.synonyms  ?? "",
            meaning: dto.meaning  ?? "",
            conjugation: dto.conjugation  ?? "",
            views: dto.views ?? 0,
            likes: dto.likes ?? 0,
            liked: false,
            createdAt: dto.createdAt  ?? "",
            updatedAt: dto.updatedAt  ?? ""
        )
    }

    static func mapToEntity(_ dto: SayingDTO) -> Saying {
        Saying(
            rid: dto.rid,
            title: dto.title  ?? "",
            meaning: dto.meaning  ?? "",
            views: dto.views ?? 0,
            likes: dto.likes ?? 0,
            liked: false,
            createdAt: dto.createdAt  ?? "",
            updatedAt: dto.updatedAt  ?? ""
        )
    }

    static func mapToEntity(_ dto: WordDTO) -> Word {
        Word(
            rid: dto.rid,
            title: dto.title  ?? "",
            synonyms: dto.synonyms  ?? "",
            meaning: dto.meaning  ?? "",
            conjugation: dto.conjugation  ?? "",
            views: dto.views ?? 0,
            likes: dto.likes ?? 0,
            liked: false,
            createdAt: dto.createdAt  ?? "",
            updatedAt: dto.updatedAt  ?? ""
        )
    }
}
