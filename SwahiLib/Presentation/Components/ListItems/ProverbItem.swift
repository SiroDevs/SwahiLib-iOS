//
//  ProverbItem.swift
//  SwahiLib
//
//  Created by Siro Daves on 12/07/2025.
//

import SwiftUI

struct ProverbItem: View {
    var proverb: Proverb

    private var titleTextStyle: Font {
        .system(size: 22, weight: .bold)
    }

    private var bodyTextStyle: Font {
        .system(size: 18)
    }

    private var meaning: String {
        let cleaned = cleanMeaning(proverb.meaning)
        let contents = cleaned.split(separator: "|")
        let extra = contents.first?.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) } ?? []

        var result = extra.first.map { " ~ \($0)." } ?? ""

        if contents.count > 1 {
            let extra2 = contents[1].split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            if let first = extra2.first {
                result += "\n ~ \(first)."
            }
        }
        return result
    }

    private var synonyms: [String] {
        (proverb.synonyms)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(proverb.title)
                .font(titleTextStyle)
                .padding(.bottom, 2)
                .lineLimit(1)
                .foregroundColor(.onPrimaryContainer)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !meaning.isEmpty {
                Text(meaning)
                    .font(bodyTextStyle)
                    .lineLimit(2)
                    .foregroundColor(.onPrimaryContainer)
                    .padding(.bottom, synonyms.isEmpty ? 0 : 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }

            if !synonyms.isEmpty {
                HStack(alignment: .center) {
                    Text(synonyms.count == 1 ? "KISAWE:" : "VISAWE \(synonyms.count):")
                        .foregroundColor(.onPrimaryContainer)
                        .font(bodyTextStyle.weight(.bold))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(synonyms, id: \.self) { synonym in
                                TagItem(tagText: synonym, height: 28)
                                    .padding(.trailing, 6)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background1)
                .shadow(color: .onPrimaryContainer.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}
