//
//  SayingItem.swift
//  SwahiLib
//
//  Created by Siro Daves on 12/07/2025.
//

import SwiftUI

struct SayingItem: View {
    var saying: Saying
    var onTap: (() -> Void)? = nil

    private var titleTextStyle: Font {
        .system(size: 22, weight: .bold)
    }

    private var bodyTextStyle: Font {
        .system(size: 18)
    }

    private var meaning: String {
        let cleaned = cleanMeaning(saying.meaning)
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
            Text(saying.title)
                .font(titleTextStyle)
                .padding(.bottom, 2)

            if !meaning.isEmpty {
                Text(meaning)
                    .font(bodyTextStyle)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .onTapGesture {
            onTap?()
        }
    }
}
