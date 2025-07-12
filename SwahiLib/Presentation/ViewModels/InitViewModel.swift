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

    func initializeDataIfNeeded() {
        guard !prefsRepo.isDataLoaded else {
            print("✅ Data already loaded, skipping initialization.")
            return
        }
        Task {
            await fetchAndSaveData()
        }
    }

    @MainActor
    private func fetchAndSaveData() async {
        uiState = .loading("Inapakia data ...")
        progress = 0

        do {
            idioms = try await idiomRepo.fetchRemoteData()
            proverbs = try await proverbRepo.fetchRemoteData()
            sayings = try await sayingRepo.fetchRemoteData()
            words = try await wordRepo.fetchRemoteData()

            uiState = .saving("Inahifadhi data ...")
            progress = 0

            try await saveIdioms()
            try await saveProverbs()
            try await saveSayings()
            try await saveWords()

            prefsRepo.isDataLoaded = true
            uiState = .saved
            print("✅ Data fetched and saved successfully.")

        } catch {
            uiState = .error("Imefeli: \(error.localizedDescription)")
            print("❌ Initialization failed: \(error)")
        }
    }

    private func saveIdioms() async throws {
        await MainActor.run { uiState = .saving("Inahifadhi nahau \(idioms.count) ...") }
        for (index, idiom) in idioms.enumerated() {
            idiomRepo.saveRemoteData([idiom])
            await updateProgress(current: index + 1, total: idioms.count)
        }
    }

    private func saveProverbs() async throws {
        await MainActor.run { uiState = .saving("Inahifadhi methali \(proverbs.count) ...") }
        for (index, proverb) in proverbs.enumerated() {
            proverbRepo.saveRemoteData([proverb])
            await updateProgress(current: index + 1, total: proverbs.count)
        }
    }

    private func saveSayings() async throws {
        await MainActor.run { uiState = .saving("Inahifadhi misemo \(sayings.count) ...") }
        for (index, saying) in sayings.enumerated() {
            sayingRepo.saveRemoteData([saying])
            await updateProgress(current: index + 1, total: sayings.count)
        }
    }

    private func saveWords() async throws {
        await MainActor.run { uiState = .saving("Inahifadhi maneno \(words.count) ...") }
        for (index, word) in words.enumerated() {
            wordRepo.saveRemoteData([word])
            await updateProgress(current: index + 1, total: words.count)
        }
    }

    @MainActor
    private func updateProgress(current: Int, total: Int) {
        guard total > 0 else { return }
        let newProgress = Int((Double(current) / Double(total)) * 100)
        if newProgress > progress {
            progress = newProgress
        }
    }
}
