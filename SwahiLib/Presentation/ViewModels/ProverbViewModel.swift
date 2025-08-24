//
//  ProverbViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class ProverbViewModel: ObservableObject {
    @Published var isActiveSubscriber: Bool = false
    
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Proverb] = []

    private let proverbRepo: ProverbRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    init(
        proverbRepo: ProverbRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol,
    ) {
        self.proverbRepo = proverbRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func loadProverb(_ proverb: Proverb) {
        uiState = .loading()
        isLiked = proverb.liked
        title = proverb.title
        conjugation = proverb.conjugation
        meanings = cleanMeaning(
            proverb.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")

        let synonymTitles = (proverb.synonyms)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        Task { @MainActor in
            if !synonymTitles.isEmpty {
                self.synonyms =  proverbRepo.getProverbsByTitles(titles: synonymTitles).sorted { ($0.title).lowercased() < ($1.title).lowercased() }
            } else {
                self.synonyms = []
            }
        }

        uiState = .loaded
    }
    
    func shareText(proverb: Proverb) -> String {
        let parts = cleanMeaning(
            proverb.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")
        
        let meaningsList: String
        if parts.count > 1 {
            meaningsList = parts.enumerated()
                .map { "\($0 + 1). \($1.trimmingCharacters(in: .whitespacesAndNewlines))" }
                .joined(separator: "\n")
        } else {
            meaningsList = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
        var text = """
        \(proverb.title) ni \(L10n.proverbKiswa)
        
        Maana:
        \(meaningsList)
        """
        
        if !proverb.conjugation.isEmpty {
            text += "\n\nMnyambuliko: \(proverb.conjugation)"
        }
        
        if !synonyms.isEmpty {
            let synonymList = synonyms.map { $0.title }.joined(separator: ", ")
            text += "\n\n\(synonyms.count == 1 ? "\(L10n.synonym): " : "\(L10n.synonyms) \(synonyms.count):\n")\(synonymList)"
        }
        
        text += "\n\n\(AppConstants.appTitle) - \(AppConstants.appTitle2)\n\(AppConstants.appLink)\n"
        
        return text
    }
    
    func likeProverb(proverb: Proverb) {
        let updatedProverb = Proverb(
            rid: proverb.rid,
            title: proverb.title,
            synonyms: proverb.synonyms,
            meaning: proverb.meaning,
            conjugation: proverb.conjugation,
            views: proverb.views,
            likes: proverb.likes,
            liked: !proverb.liked,
            createdAt: proverb.createdAt,
            updatedAt: proverb.updatedAt
        )
        
        proverbRepo.updateProverb(updatedProverb)
        isLiked = updatedProverb.liked
        uiState = .liked
    }
}
