//
//  SayingViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class SayingViewModel: ObservableObject {
    @Published var isActiveSubscriber: Bool = false
    
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []

    private let sayingRepo: SayingRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    init(
        sayingRepo: SayingRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.sayingRepo = sayingRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func loadSaying(_ saying: Saying) {
        uiState = .loading()
        isLiked = saying.liked
        title = saying.title
        meanings = cleanMeaning(
            saying.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")

        uiState = .loaded
    }

    func likeSaying(saying: Saying) {
        let updatedSaying = Saying(
            rid: saying.rid,
            title: saying.title,
            meaning: saying.meaning,
            views: saying.views,
            likes: saying.likes,
            liked: !saying.liked,
            createdAt: saying.createdAt,
            updatedAt: saying.updatedAt
        )
        
        sayingRepo.updateSaying(updatedSaying)
        isLiked = updatedSaying.liked
        uiState = .liked
    }
}
