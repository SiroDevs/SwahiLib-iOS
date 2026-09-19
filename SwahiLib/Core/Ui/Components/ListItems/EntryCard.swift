//
//  EntryCard.swift
//  SwahiLib
//
//  Created by @sirodevs on 19/09/2026.
//

import SwiftUI

enum EntryStyle {
    static let title = Font.system(size: 18, weight: .bold)
    static let english = Font.system(size: 14, weight: .medium).italic()
    static let meaning = Font.system(size: 14)
    static let chip = Font.system(size: 11, weight: .medium)
    static let timestamp = Font.system(size: 11)
}

enum EntryAccent {
    static let word = Color.primary1
    static let idiom = Color.primary2.opacity(0.6)
    static let proverb = Color.primary2.opacity(0.35)
    static let saying = Color.onPrimaryContainer.opacity(0.3)
}

struct EntryCard<Content: View>: View {
    let accent: Color
    let liked: Bool
    let barHeight: CGFloat
    let content: Content

    init(
        accent: Color,
        liked: Bool = false,
        barHeight: CGFloat = 42,
        @ViewBuilder content: () -> Content
    ) {
        self.accent = accent
        self.liked = liked
        self.barHeight = barHeight
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(liked ? Color.primary2 : accent)
                .frame(width: 4, height: barHeight)

            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.background1)
                .shadow(color: Color.onPrimaryContainer.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .contentShape(Rectangle())
    }
}

struct EntryTitleRow: View {
    let title: String
    var english: String = ""
    var liked: Bool = false
    var lineLimit: Int? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(EntryStyle.title)
                .foregroundColor(.onPrimaryContainer)
                .lineLimit(lineLimit)
                .fixedSize(horizontal: false, vertical: lineLimit == nil)
                .multilineTextAlignment(.leading)
                .layoutPriority(1)

            if !english.isEmpty {
                Text(english)
                    .font(EntryStyle.english)
                    .foregroundColor(.primary2)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            if liked {
                Image(systemName: "heart.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.primary2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EntryMeaningText: View {
    let text: String

    var body: some View {
        if !text.isEmpty {
            Text(text)
                .font(EntryStyle.meaning)
                .foregroundColor(Color.onPrimaryContainer.opacity(0.75))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 2)
        }
    }
}

struct SynonymChips: View {
    let synonyms: [String]

    var body: some View {
        if !synonyms.isEmpty {
            HStack(spacing: 4) {
                ForEach(Array(synonyms.prefix(3).enumerated()), id: \.offset) { _, synonym in
                    Text(synonym)
                        .font(EntryStyle.chip)
                        .foregroundColor(.onPrimaryContainer)
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.primary2.opacity(0.14)))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 6)
        }
    }
}

struct EntryTimestamp: View {
    let text: String?

    var body: some View {
        if let text, !text.isEmpty {
            Text(text)
                .font(EntryStyle.timestamp)
                .foregroundColor(Color.onPrimaryContainer.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
    }
}

func entryMeaning(_ raw: String, includeSecond: Bool = false) -> String {
    let segments = cleanText(raw).split(separator: "|")

    func head(_ segment: Substring) -> String {
        segment.split(separator: ":").first
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? ""
    }

    var result = segments.first.map(head) ?? ""

    if includeSecond, segments.count > 1 {
        let second = head(segments[1])
        if !second.isEmpty {
            result = result.isEmpty ? second : "\(result)\n\(second)"
        }
    }
    return result
}
