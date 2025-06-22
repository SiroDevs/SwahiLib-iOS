//
//  Step1ViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class InitViewModel: ObservableObject {
    @Published var idioms: [Idiom] = []
    @Published var proverbs: [Proverb] = []
    @Published var sayings: [Saying] = []
    @Published var words: [Word] = []
    @Published var uiState: ViewUiState = .idle

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
        wordRepo: WordRepositoryProtocol,
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
    }
    
    func fetchWords() {
        uiState = .loading("Fetching data ...")

        Task {
            do {
                self.idioms = try await idiomRepo.fetchRemoteData()
                self.proverbs = try await proverbRepo.fetchRemoteData()
                self.sayings = try await sayingRepo.fetchRemoteData()
                self.words = try await wordRepo.fetchRemoteData()
                
                await MainActor.run {
                    self.uiState = .fetched
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error("Failed to fetch data: \(error)")
                }
            }
        }
    }

    func saveProverbs() {
        self.uiState = .saving("Saving proverbs ...")
                
        Task {
            self.proverbRepo.saveData(proverbs)
            
            await MainActor.run {
                self.uiState = .saved
            }
        }
    }
    
    func saveSayings() {
        self.uiState = .saving("Saving sayings ...")
                
        Task {
            self.sayingRepo.saveData(sayings)
            
            await MainActor.run {
                self.uiState = .saved
            }
        }
    }
    
    func saveWords() {
        self.uiState = .saving("Saving words ...")
                
        Task {
            self.wordRepo.saveData(words)
            
            await MainActor.run {
                self.prefsRepo.isDataLoaded = true
                self.uiState = .saved
            }
        }
    }
}
