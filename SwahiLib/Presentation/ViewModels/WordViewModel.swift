//
//  WordViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class WordViewModel: ObservableObject {
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Word] = []

    private var cancellables = Set<AnyCancellable>()
    private let wordRepo: WordRepository

    init(wordRepo: WordRepository) {
        self.wordRepo = wordRepo
    }

    func loadWord(_ word: Word) {
        uiState = .loading()
        isLiked = word.liked
        title = word.title
        conjugation = word.conjugation
        meanings = cleanMeaning(word.meaning).components(separatedBy: "|")

        let synonymTitles = (word.synonyms)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if !synonymTitles.isEmpty {
            wordRepo.getWordsByTitles(titles: synonymTitles)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { [weak self] words in
                          self?.synonyms = words.sorted { ($0.title ?? "").lowercased() < ($1.title ?? "").lowercased() }
                      })
                .store(in: &cancellables)
        } else {
            synonyms = []
        }

        uiState = .loaded
    }

    func likeWord(_ word: Word) {
//        let updatedWord = word.copyWith(liked: !word.liked)
//        wordRepo.updateWord(updatedWord)
//        isLiked = updatedWord.liked
    }
}
