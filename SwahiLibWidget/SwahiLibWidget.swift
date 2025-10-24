//
//  SwahiLibWidgetBundle.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit
import SwiftUI

@main
struct DailyTipWidget: Widget {
    let kind: String = "SwahiLibWidgetBundle"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DailyTipProvider(),
            content: { DailyTipWidgetView(entry: $0) }
        )
        .configurationDisplayName("Neno la Siku")
        .description("Neno la kuchangamsha siku yako!")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    DailyTipWidget()
} timeline: {
    TipEntry(date: .now, dailyTip: "Baba")
}

#Preview(as: .systemLarge) {
    DailyTipWidget()
} timeline: {
    TipEntry(date: .now, dailyTip: "Baba")
}
