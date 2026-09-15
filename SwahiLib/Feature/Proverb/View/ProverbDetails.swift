//
//  ProverbDetails.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//
//  Restyled to match Android's ProverbDetails.kt: same literal/figurative
//  meaning split and first/second-explanation logic as before (unchanged),
//  now sharing the same MeaningsView card component Word uses (Android
//  reuses core/ui's MeaningsView for proverbs too, rather than a
//  proverb-specific card), and explanation badges as filled pills
//  instead of plain colored text.

import SwiftUI

struct ProverbDetails: View {
    @ObservedObject var viewModel: ProverbViewModel
    let title: String
    let meanings: [String]
    let synonyms: [Proverb]
    let explanations: [String]
    let onFeatureLocked: () -> Void
    
    private var hasLiteralAndFigurativeMeanings: Bool {
        meanings.indices.contains(1) && !meanings[1].isEmpty
    }
    
    private var literalMeanings: [String] {
        return meanings[0]
            .split(separator: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    private var figurativeMeanings: [String] {
        guard !meanings[1].isEmpty else { return [] }
        return meanings[1]
            .split(separator: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    private var hasFirstExplanation: Bool {
        explanations.indices.contains(0) && !explanations[0].isEmpty
    }
    
    private var hasSecondExplanation: Bool {
        explanations.indices.contains(1) && !explanations[1].isEmpty
    }
    
    private var synonymsTitle: String {
        if synonyms.count == 1 {
            return L10n.synonym.uppercased()
        } else {
            return "\(L10n.synonyms.uppercased()) \(synonyms.count)"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CollapsingHeader(title: title)

                VStack(alignment: .leading, spacing: 12) {
                    if hasFirstExplanation {
                        explanationBadge(text: "ni methali \(explanations[0])", italic: false)
                    }

                    if !synonyms.isEmpty {
                        synonymsSection
                    }

                    if !meanings.isEmpty {
                        if hasLiteralAndFigurativeMeanings {
                            sectionHeader("MAANA HALISI")
                            MeaningsView(meanings: literalMeanings)

                            sectionHeader("MAANA YA KIFALSAFA/KIMAFUMBO")
                            MeaningsView(meanings: figurativeMeanings)
                        } else {
                            sectionHeader("MAANA YA METHALI")
                            MeaningsView(meanings: literalMeanings)
                        }
                    }

                    if hasSecondExplanation {
                        explanationBadge(text: explanations[1], italic: true)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary1)
    }

    private func explanationBadge(text: String, italic: Bool) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
            .italic(italic)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.primary2))
    }
    
    private var synonymsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(synonymsTitle)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary1)
            
            VStack(spacing: 0) {
                ForEach(synonyms, id: \.id) { synonym in
                    SynonymItem(
                        title: synonym.title,
                        onClick: {
                            handleSynonymClick(synonym)
                        }
                    )
                }
            }
        }
    }
    
    private func handleSynonymClick(_ synonym: Proverb) {
        if viewModel.isProUser {
            viewModel.loadProverb(synonym)
        } else {
            onFeatureLocked()
        }
    }
}

#Preview{
    ProverbView(
        proverb: Proverb.sampleProverbs[0]
    )
}
