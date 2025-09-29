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
    @Published var isProUser: Bool = false
    
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
        subsRepo.isProUser { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isProUser = isActive
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
    
    func shareText(idiom: Idiom) -> String {
        let parts = cleanMeaning(
            idiom.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
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
        \(idiom.title) ni \(L10n.idiomKiswa)
        
        Maana:
        \(meaningsList)
        """
        
        text += "\n\n\(AppConstants.appTitle) - \(AppConstants.appTitle2)\n\(AppConstants.appLink)\n"
        
        return text
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
