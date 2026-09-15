//
//  MeaningsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//
import SwiftUI

struct MeaningsView: View {
    let meanings: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(meanings.enumerated()), id: \.offset) { index, meaning in
                let parts = meaning.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
                let maana = parts.first ?? ""
                let mfano = parts.count > 1 ? parts[1] : nil

                if !maana.isEmpty {
                    MeaningCard(
                        maana: maana,
                        mfano: mfano,
                        index: index,
                        total: meanings.count
                    )
                }
            }
        }
    }
}

struct MeaningCard: View {
    let maana: String
    let mfano: String?
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                if total > 1 {
                    Text("\(index + 1)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.primary2))
                        .padding(.top, 2)
                }

                Text(maana)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.onPrimaryContainer)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let mfano = mfano, !mfano.isEmpty {
                Divider()
                    .background(Color.primary2.opacity(0.3))
                    .padding(.vertical, 10)

                (
                    Text("Mfano: ").bold()
                    + Text(mfano).italic()
                )
                .font(.system(size: 17))
                .foregroundColor(.onPrimaryContainer.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.background1))
    }
}

#Preview{
    WordView(
        deepLinked: false, word: Word.sampleWords[0]
    )
}
