//
//  SwahiLibWidgetBundle.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit
import SwiftUI

@main
struct SwahiLibWidget: Widget {
    let kind: String = "SwahiLibWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DailyWordProvider()
        ) { entry in
            WordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Neno la Siku")
        .description("Jifunze neno jipya la Kiswahili kila siku.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SwahiLibWidget()
} timeline: {
    WordEntry.sampleWords[0]
}
