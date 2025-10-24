//
//  WordWidgetView.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit
import SwiftUI

struct WordWidgetEntryView: View {
    var entry: DailyWordProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWordView(entry: entry)
        case .systemMedium:
            MediumWordView(entry: entry)
        default:
            MediumWordView(entry: entry)
        }
    }
}

struct SmallWordView: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Neno la Leo")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blue)
            
            Text(entry.title)
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(.primary)
            
            Text(entry.meaning)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWordView: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Neno la Leo")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "book.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 12))
            }
            
            Text(entry.title)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(.primary)
            
            Text(entry.meaning)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            if !entry.synonyms.isEmpty && entry.synonyms != "N/A" {
                Text("Visawe: \(entry.synonyms)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
