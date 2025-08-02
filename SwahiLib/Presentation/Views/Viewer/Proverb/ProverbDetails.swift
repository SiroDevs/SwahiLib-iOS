//
//  ProverbDetails.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//
import SwiftUI

struct ProverbDetails: View {
    @ObservedObject var viewModel: ProverbViewModel
    var title: String
    var meanings: [String]
    var synonyms: [Proverb]
    var conjugation: String

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

                    Text(synonyms.count == 1 ? "KISAWE" : "VISAWE \(synonyms.count)")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color(.primary1))
                        .padding(.leading, 10)

                    ProverbSynonyms(
                        synonyms: synonyms,
                        onSynonymClicked: { synonym in
                            viewModel.loadProverb(synonym)
                        }
                    )
                }
            }
        }
    }
}

struct ProverbSynonyms: View {
    var synonyms: [Proverb]
    var onSynonymClicked: (Proverb) -> Void

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
