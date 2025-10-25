//
//  WordDetails.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

import SwiftUI

struct WordDetails: View {
    @ObservedObject var viewModel: WordViewModel
    var title: String
    var meanings: [String]
    var synonyms: [Word]
    var conjugation: String
    var onFeatureLocked: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CollapsingHeader(title: title)

                if !meanings.isEmpty {
                    MeaningsView(meanings: meanings)
                }

                if !conjugation.isEmpty {
                    (
                        Text("Mnyambuliko: ")
                            .bold() +
                        Text(conjugation)
                            .italic()
                    )
                    .padding(.leading, 20)
                    .font(.system(size: 20))
                    .foregroundColor(Color(.primary1))
                }

                if !synonyms.isEmpty {
                    Spacer().frame(height: 20)

                    Text(synonyms.count == 1 ? L10n.synonym : "\(L10n.synonyms) \(synonyms.count)")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.primary1)
                        .padding(.leading, 10)

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
        }
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
        .padding(.horizontal, 20)
    }
}

#Preview{
    WordView(
        word: Word.sampleWords[0]
    )
}
