//
//  WordDetails.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//
import SwiftUI

struct WordDetails: View {
    @ObservedObject var viewModel: WordViewModel
    var title: String
    var conjugation: String
    var meanings: [String]
    var synonyms: [Word]

    var body: some View {
        ScrollView {
            VStack {
                CollapsingHeader(title: title)

                VStack(alignment: .leading, spacing: 16) {
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
                        .font(.system(size: 20))
                        .foregroundColor(Color(.primary1))
                        .padding(.leading, 10)
                    }

                    if !synonyms.isEmpty {
                        Spacer().frame(height: 20)

                        Text(synonyms.count == 1 ? "KISAWE" : "VISAWE \(synonyms.count)")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(.primary1))
                            .padding(.leading, 10)

                        WordSynonyms(
                            synonyms: synonyms,
                            onSynonymClicked: { synonym in
                                viewModel.loadWord(synonym)
                            }
                        )
                    }
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
    }
}

#Preview{
    WordView(
        word: Word.sampleWords[0]
    )
}
