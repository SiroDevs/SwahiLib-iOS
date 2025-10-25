//
//  DailyWordProvider.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit

struct DailyWordProvider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry.sampleWords[0]
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> ()) {
        let entry = getCurrentWordEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> ()) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate).addingTimeInterval(86400)
        let entry = getCurrentWordEntry()
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }
    
    private func getCurrentWordEntry() -> WordEntry {
//        if let wordData = SharedWidgetManager.getCurrentWord() {
//            return WordEntry(
//                date: Date(),
//                title: wordData.title,
//                meaning: wordData.meaning,
//                synonyms: wordData.synonyms,
//                conjugation: wordData.conjugation
//            )
//        } else {
//            return WordEntry.sampleWords[0]
//        }
        return WordEntry.sampleWords[0]
    }
}
