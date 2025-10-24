//
//  WordViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class WordViewModel: ObservableObject {
    @Published var isProUser: Bool = false
    
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Word] = []

    private let wordRepo: WordRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    init(
        wordRepo: WordRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isProUser { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isProUser = isActive
            }
        }
    }
    
    func loadWord(_ word: Word) {
        uiState = .loading()
        isLiked = word.liked
        title = word.title
        conjugation = word.conjugation
        
        checkSubscription()
        meanings = cleanMeaning(
            word.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")

        let synonymTitles = (word.synonyms)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        Task { @MainActor in
            if !synonymTitles.isEmpty {
                self.synonyms =  wordRepo.getWordsByTitles(titles: synonymTitles).sorted { ($0.title).lowercased() < ($1.title).lowercased() }
            } else {
                self.synonyms = []
            }
        }
        
        uiState = .loaded
    }
    
    func shareText(word: Word) -> String {
        let parts = cleanMeaning(
            word.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
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
        \(word.title) ni \(L10n.wordKiswa)
        
        Maana:
        \(meaningsList)
        """
        
        if !word.conjugation.isEmpty {
            text += "\n\nMnyambuliko: \(word.conjugation)"
        }
        
        if !synonyms.isEmpty {
            let synonymList = synonyms.map { $0.title }.joined(separator: ", ")
            text += "\n\n\(synonyms.count == 1 ? "\(L10n.synonym): " : "\(L10n.synonyms) \(synonyms.count):\n")\(synonymList)"
        }
        
        text += "\n\n\(AppConstants.appTitle) - \(AppConstants.appTitle2)\n\(AppConstants.appLink)\n"
        
        return text
    }

    func likeWord(word: Word) {
        let updatedWord = Word(
            rid: word.rid,
            title: word.title,
            synonyms: word.synonyms,
            meaning: word.meaning,
            conjugation: word.conjugation,
            views: word.views,
            likes: word.likes,
            liked: !word.liked,
            createdAt: word.createdAt,
            updatedAt: word.updatedAt
        )
        
        wordRepo.updateWord(updatedWord)
        isLiked = updatedWord.liked
        uiState = .liked
    }
}
