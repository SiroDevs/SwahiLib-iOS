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
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Proverb] = []

    private var cancellables = Set<AnyCancellable>()
    private let proverbRepo: ProverbRepository

    init(proverbRepo: ProverbRepository) {
        self.proverbRepo = proverbRepo
    }

    func loadProverb(_ proverb: Proverb) {
        uiState = .loading()
        isLiked = proverb.liked
        title = proverb.title
        conjugation = proverb.conjugation
        meanings = cleanMeaning(proverb.meaning).components(separatedBy: "|")

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

    func likeProverb(_ proverb: Proverb) {
//        let updatedProverb = proverb.copyWith(liked: !proverb.liked)
//        proverbRepo.updateProverb(updatedProverb)
//        isLiked = updatedProverb.liked
    }
}
