//
//  CollapsingHeader.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//
//  Restyled to match Android's core/ui CollapsingHeader.kt: plain title +
//  italic subtitle text on the page background, no colored banner. Used
//  by WordDetails, ProverbDetails, and DailyContentScaffold.

import SwiftUI

struct CollapsingHeader: View {
    var title: String
    var subtitle: String? = nil

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            Text(title)
                .foregroundColor(.onSurface)
                .font(.system(size: 28, weight: .bold))
                .lineLimit(1)

            if let subtitle = subtitle, !subtitle.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(subtitle)
                    .foregroundColor(.primary1)
                    .italic()
                    .font(.system(size: 18))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview{
    CollapsingHeader(title: "This is a test")
}
