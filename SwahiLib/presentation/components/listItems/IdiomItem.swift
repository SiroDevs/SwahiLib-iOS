//
//  IdiomItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/07/2025.
//

import SwiftUI

struct IdiomItem: View {
    var idiom: Idiom

    private var titleTextStyle: Font {
        .system(size: 22, weight: .bold)
    }

    private var bodyTextStyle: Font {
        .system(size: 18)
    }

    private var meaning: String {
        let cleaned = cleanMeaning(idiom.meaning)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idiom.title)
                .font(titleTextStyle)
                .padding(.bottom, 2)
                .foregroundColor(.onPrimaryContainer)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !meaning.isEmpty {
                Text(meaning)
                    .font(bodyTextStyle)
                    .lineLimit(2)
                    .padding(.bottom, 4)
                    .foregroundColor(.onPrimaryContainer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
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
