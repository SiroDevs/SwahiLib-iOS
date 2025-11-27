//
//  ProverbDetails.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

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
            return L10n.synonym
        } else {
            return "\(L10n.synonyms) \(synonyms.count)"
        }
    }
    
    private enum Constants {
        static let sizeXSmall: CGFloat = 2
        static let sizeSmall: CGFloat = 5
        static let sizeMedium: CGFloat = 10
        static let sizeLarge: CGFloat = 15
        static let fontSizeTitle: CGFloat = 20
        static let fontSizeBody: CGFloat = 16
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.sizeMedium) {
                CollapsingHeader(title: title)
                
                if hasFirstExplanation {
                    firstExplanationView
                }
                
                if !synonyms.isEmpty {
                    synonymsSection
                }
                
                if !meanings.isEmpty {
                    if hasLiteralAndFigurativeMeanings {
                        Spacer().frame(height: Constants.sizeXSmall)
                        Text("MAANA HALISI")
                            .bold()
                            .font(.system(size: Constants.fontSizeTitle))
                            .padding(.horizontal, Constants.sizeLarge)
                        ProverbMeaning(meanings: literalMeanings)
                        
                        Spacer().frame(height: Constants.sizeXSmall)
                        Text("MAANA YA KIFALSAFA/KIMAFUMBO")
                            .bold()
                            .font(.system(size: Constants.fontSizeTitle))
                            .padding(.leading, Constants.sizeLarge)
                        ProverbMeaning(meanings: figurativeMeanings)
                    } else {
                        Text("MAANA YA METHALI")
                            .bold()
                            .font(.system(size: Constants.fontSizeTitle))
                            .padding(.leading, Constants.sizeLarge)
                        ProverbMeaning(meanings: literalMeanings)
                    }
                }
                
                if hasSecondExplanation {
                    secondExplanationView
                }
            }
        }
    }
    
    private var firstExplanationView: some View {
        Text("ni methali \(explanations[0])")
            .bold()
            .font(.system(size: Constants.fontSizeBody))
            .foregroundColor(.primary1)
            .padding(.horizontal, Constants.sizeMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var secondExplanationView: some View {
        Text(explanations[1])
            .italic()
            .font(.system(size: Constants.fontSizeBody))
            .foregroundColor(.primary1)
            .padding(.horizontal, Constants.sizeMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var synonymsSection: some View {
        VStack(alignment: .leading, spacing: Constants.sizeMedium) {
            Text(synonymsTitle)
                .font(.system(size: Constants.fontSizeTitle, weight: .bold))
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
            .padding(.horizontal, Constants.sizeMedium)
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
