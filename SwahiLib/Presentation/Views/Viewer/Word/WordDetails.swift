//
//  WordDetails.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//

import SwiftUI

struct WordDetails: View {
    var viewModel: WordViewModel
    var title: String
    var conjugation: String
    var meanings: [String]
    var synonyms: [Word]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CollapsingHeader(title: title)

                VStack(alignment: .leading, spacing: 16) {
                    if !meanings.isEmpty {
                        MeaningsView(meanings: meanings)
                    }

                    if !conjugation.isEmpty {
                        TextGroup(label: "Mnyambuliko:", value: conjugation)
                    }

                    if !synonyms.isEmpty {
                        Text("VISAWE \(synonyms.count)")
                            .font(.title2.bold())
                            .foregroundColor(.primary1)
                            .padding(.top)

                        WordSynonyms(
                            synonyms: synonyms,
                            onSynonymClicked: { synonym in
                                viewModel.loadWord(synonym)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .background(ThemeColors.accent0)
    }
}

private struct TextGroup: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .bold()
            Text(value)
                .italic()
        }
        .font(.title3)
        .foregroundColor(ThemeColors.primary1)
        .padding(.leading)
    }
}
