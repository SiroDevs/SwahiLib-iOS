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

    @Published var uiState: UiState = .idle
    @Published var progress: Int = 0

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

    func initializeData() {
        Task {
            await fetchAndSaveData()
        }
    }

    func fetchAndSaveData() async {
        await MainActor.run {
            self.uiState = .loading("Inapakia data ...")
            self.progress = 0
        }

        do {
            let fetchedIdioms = try await idiomRepo.fetchRemoteData()
            let fetchedProverbs = try await proverbRepo.fetchRemoteData()
            let fetchedSayings = try await sayingRepo.fetchRemoteData()
            let fetchedWords = try await wordRepo.fetchRemoteData()

            await MainActor.run {
                self.idioms = fetchedIdioms
                self.proverbs = fetchedProverbs
                self.sayings = fetchedSayings
                self.words = fetchedWords

                self.uiState = .saving("Inahifadhi data ...")
                self.progress = 0
            }

            try await saveIdioms()
            try await saveProverbs()
            try await saveSayings()
            try await saveWords()

            prefsRepo.isDataLoaded = true

            await MainActor.run {
                self.uiState = .saved
            }

            print("✅ Data fetched and saved successfully.")

        } catch {
            await MainActor.run {
                self.uiState = .error("Imefeli: \(error.localizedDescription)")
            }
            print("❌ Initialization failed: \(error)")
        }
    }


    private func saveIdioms() async throws {
        await MainActor.run {
            self.progress = 0
            self.uiState = .saving("Inahifadhi nahau \(idioms.count) ...")
        }

        for (index, idiom) in idioms.enumerated() {
            idiomRepo.saveIdiom(idiom)
            await MainActor.run {
                self.updateProgress(current: index + 1, total: idioms.count)
            }
        }
    }

    private func saveProverbs() async throws {
        await MainActor.run {
            self.progress = 0
            self.uiState = .saving("Inahifadhi methali \(proverbs.count) ...")
        }

        for (index, proverb) in proverbs.enumerated() {
            proverbRepo.saveProverb(proverb)
            await MainActor.run {
                self.updateProgress(current: index + 1, total: proverbs.count)
            }
        }
    }

    private func saveSayings() async throws {
        await MainActor.run {
            self.progress = 0
            self.uiState = .saving("Inahifadhi misemo \(sayings.count) ...")
        }

        for (index, saying) in sayings.enumerated() {
            sayingRepo.saveSaying(saying)
            await MainActor.run {
                self.updateProgress(current: index + 1, total: sayings.count)
            }
        }
    }

    private func saveWords() async throws {
        await MainActor.run {
            self.progress = 0
            self.uiState = .saving("Inahifadhi maneno \(words.count) ...")
        }

        for (index, word) in words.enumerated() {
            wordRepo.saveWord(word)
            await MainActor.run {
                self.updateProgress(current: index + 1, total: words.count)
            }
        }
    }

    @MainActor
    private func updateProgress(current: Int, total: Int) {
        guard total > 0 else { return }
        let newProgress = Int((Double(current) / Double(total)) * 100)
        if newProgress > progress {
            self.progress = newProgress
        }
    }
}
