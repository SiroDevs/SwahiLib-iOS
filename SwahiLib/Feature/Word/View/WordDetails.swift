//
//  WordDetails.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//
//  Restyled to match Android's feature/word WordView.kt: meanings render
//  directly under the header with no extra "MAANA" label (Android only
//  labels sections when there's more than one meaning category, which a
//  single word never has), and the conjugation is now a labelled card
//  ("MNYAMBULIKO") instead of plain text.
//
//  "METHALI AMBATANISHI" (related proverbs) has no Android equivalent —
//  it's a pre-existing iOS-only addition, kept as-is.

import SwiftUI

struct WordDetails: View {
    @ObservedObject var viewModel: WordViewModel
    var title: String
    var meanings: [String]
    var synonyms: [Word]
    var conjugation: String
    var proverbs: [Proverb]
    var english: String?
    var onFeatureLocked: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CollapsingHeader(title: title, subtitle: english)

                VStack(alignment: .leading, spacing: 16) {
                    if !meanings.isEmpty {
                        MeaningsView(meanings: meanings)
                    }

                    if !conjugation.isEmpty {
                        conjugationCard
                    }

                    if !synonyms.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(synonyms.count == 1 ? L10n.synonym.uppercased() : "\(L10n.synonyms.uppercased()) (\(synonyms.count))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary1)

                            WordSynonyms(
                                synonyms: synonyms,
                                onSynonymClicked: { synonym in
                                    if viewModel.isProUser {
                                        viewModel.loadWord(synonym)
                                    } else {
                                        onFeatureLocked()
                                    }
                                }
                            )
                        }
                    }

                    if !proverbs.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("METHALI AMBATANISHI \(proverbs.count)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary1)

                            ProverbsList(proverbs: proverbs)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private var conjugationCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("MNYAMBULIKO")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary2)
                .tracking(1.5)

            Text(conjugation)
                .italic()
                .font(.system(size: 17))
                .foregroundColor(.onSurface)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.background1))
    }
}

struct WordSynonyms: View {
    var synonyms: [Word]
    var onSynonymClicked: (Word) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(synonyms, id: \.id) { synonym in
                SynonymItem(
                    title: synonym.title,
                    onClick: {
                        onSynonymClicked(synonym)
                    }
                )
            }
        }
    }
}

#Preview{
    WordView(
        deepLinked: false, word: Word.sampleWords[0]
    )
}
