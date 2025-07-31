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
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Idiom] = []

    private var cancellables = Set<AnyCancellable>()
    private let idiomRepo: IdiomRepository

    init(idiomRepo: IdiomRepository) {
        self.idiomRepo = idiomRepo
    }

    func loadIdiom(_ idiom: Idiom) {
        uiState = .loading()
        isLiked = idiom.liked
        title = idiom.title
        meanings = cleanMeaning(idiom.meaning).components(separatedBy: "|")

        uiState = .loaded
    }

    func likeIdiom(_ idiom: Idiom) {
//        let updatedIdiom = idiom.copyWith(liked: !idiom.liked)
//        idiomRepo.updateIdiom(updatedIdiom)
//        isLiked = updatedIdiom.liked
    }
}
