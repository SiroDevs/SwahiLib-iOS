//
//  IdiomViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class IdiomViewModel: ObservableObject {
    @Published var isActiveSubscriber: Bool = false
    
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []

    private let idiomRepo: IdiomRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    init(
        idiomRepo: IdiomRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.idiomRepo = idiomRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func loadIdiom(_ idiom: Idiom) {
        uiState = .loading()
        isLiked = idiom.liked
        title = idiom.title
        meanings = cleanMeaning(
            idiom.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")

        uiState = .loaded
    }

    func likeIdiom(idiom: Idiom) {
        let updatedIdiom = Idiom(
            rid: idiom.rid,
            title: idiom.title,
            meaning: idiom.meaning,
            views: idiom.views,
            likes: idiom.likes,
            liked: !idiom.liked,
            createdAt: idiom.createdAt,
            updatedAt: idiom.updatedAt
        )
        
        idiomRepo.updateIdiom(updatedIdiom)
        isLiked = updatedIdiom.liked
        uiState = .liked
    }
}
