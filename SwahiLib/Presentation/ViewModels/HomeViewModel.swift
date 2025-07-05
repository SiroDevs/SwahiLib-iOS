//
//  HomeViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var allIdioms: [Idiom] = []
    @Published var allProverbs: [Proverb] = []
    @Published var allSayings: [Saying] = []
    @Published var allWords: [Word] = []
    @Published var filteredIdioms: [Idiom] = []
    @Published var filteredProverbs: [Proverb] = []
    @Published var filteredSayings: [Saying] = []
    @Published var filteredWords: [Word] = []
    @Published var uiState: UiState = .idle

    private let prefsRepo: PrefsRepository
    private let wordRepo: WordRepositoryProtocol

    init(
        prefsRepo: PrefsRepository,
        wordRepo: WordRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.wordRepo = wordRepo
    }
    
    func fetchData() {
        self.uiState = .loading

        Task {
            await MainActor.run {
                self.allWords = wordRepo.fetchLocalData()
                self.uiState = .loaded
            }
        }
    }
    
    func filterData(tab: HomeTab, qry: String) {
        self.uiState = .filtering

        Task {
            await MainActor.run {
                switch tab {
                    case .idioms:
                        self.filteredIdioms = allIdioms
                        
                    case .sayings:
                        self.filteredSayings = allSayings
                        
                    case .proverbs:
                        self.filteredProverbs = allProverbs
                    
                    case .words:
                        self.filteredWords = allWords
                }
                self.uiState = .filtered
            }
        }
    }
    
    func searchSongs(searchText: String) {
        if searchText.isEmpty {
            filteredWords = allWords
        } else {
//            filteredWords = allWords.filter {
//                $0.title?.lowercased().contains(searchText.lowercased())!
//            }
        }
    }

}
