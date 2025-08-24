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
