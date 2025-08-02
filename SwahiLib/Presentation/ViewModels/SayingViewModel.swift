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
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []

    private let sayingRepo: SayingRepositoryProtocol

    init(
        sayingRepo: SayingRepositoryProtocol
    ) {
        self.sayingRepo = sayingRepo
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

    func likeSaying(_ saying: Saying) {
//        let updatedSaying = saying.copyWith(liked: !saying.liked)
//        sayingRepo.updateSaying(updatedSaying)
//        isLiked = updatedSaying.liked
    }
}
