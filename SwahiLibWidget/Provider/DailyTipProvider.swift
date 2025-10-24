//
//  DailyTipProvider.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit

struct DailyTipProvider: TimelineProvider {
    private let dailyTips = Tips()
    private let placeholderEntry = TipEntry(
        date: Date(),
        dailyTip: ""
    )
    
    func placeholder(in context: Context) -> TipEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TipEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TipEntry>) -> Void) {
        let currentDate = Date()
        var entries : [TipEntry] = []
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = TipEntry(date: entryDate, dailyTip: dailyTips.tipsList[Int.random(in: 0...dailyTips.tipsList.count-1)])
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}
