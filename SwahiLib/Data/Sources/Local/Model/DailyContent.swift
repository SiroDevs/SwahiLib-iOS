//
//  DailyContent.swift
//  SwahiLib
//
//  One row per calendar day, holding that day's picked word + proverb.
//  Mirrors Android's DailyContentEntity (core/database/entities/daily).
//

import Foundation

struct DailyContent: Identifiable, Codable {
    var id: String { date }
    let date: String
    let wordRid: Int
    let wordMeaning: String
    let proverbRid: Int
    let proverbMeaning: String
}
