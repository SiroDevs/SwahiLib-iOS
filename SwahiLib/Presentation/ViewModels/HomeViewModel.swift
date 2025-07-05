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
    @Published var filteredIdioms: [Idiom] = []
    
    @Published var allProverbs: [Proverb] = []
    @Published var filteredProverbs: [Proverb] = []
    
    @Published var allSayings: [Saying] = []
    @Published var filteredSayings: [Saying] = []
    
    @Published var allWords: [Word] = []
    @Published var filteredWords: [Word] = []
    
    @Published var uiState: UiState = .idle

    private let prefsRepo: PrefsRepository
    private let idiomRepo: IdiomRepositoryProtocol
    private let proverbRepo: ProverbRepositoryProtocol
    private let sayingRepo: SayingRepositoryProtocol
    private let wordRepo: WordRepositoryProtocol

    init(
        prefsRepo: PrefsRepository,
        idiomRepo: IdiomRepositoryProtocol,
        proverbRepo: ProverbRepositoryProtocol,
        sayingRepo: SayingRepositoryProtocol,
        wordRepo: WordRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
    }
    
    func fetchData() {
        print("Fetching data")
        self.uiState = .loading("Inapakia data ...")

        Task {
            await MainActor.run {
                self.allIdioms = idiomRepo.fetchLocalData()
                self.allProverbs = proverbRepo.fetchLocalData()
                self.allSayings = sayingRepo.fetchLocalData()
                self.allWords = wordRepo.fetchLocalData()
                self.uiState = .loaded
            }
        }
    }
    
    func filterData(tab: HomeTab, qry: String) {
        Task {
            await MainActor.run {
                print("Filtering data")
                self.uiState = .filtering
                switch tab {
                    case .idioms:
                        print("Filtering idioms")
                        self.filteredIdioms = allIdioms
                        
                    case .sayings:
                        print("Filtering sayings")
                        self.filteredSayings = allSayings
                        
                    case .proverbs:
                        print("Filtering proverbs")
                        self.filteredProverbs = allProverbs
                    
                    case .words:
                        print("Filtering words")
                        self.filteredWords = allWords
                }
                self.uiState = .filtered
            }
        }
    }
    
}
