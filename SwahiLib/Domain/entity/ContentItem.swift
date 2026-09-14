//
//  ContentItem.swift
//  SwahiLib
//
//  A reading-history row resolved to its actual content, mirrors Android's
//  feature/history/model/ContentItem.kt.
//

import Foundation

enum ContentItem {
    case word(Word)
    case idiom(Idiom)
    case proverb(Proverb)
    case saying(Saying)

    var title: String {
        switch self {
        case .word(let w): return w.title
        case .idiom(let i): return i.title
        case .proverb(let p): return p.title
        case .saying(let s): return s.title
        }
    }
}
