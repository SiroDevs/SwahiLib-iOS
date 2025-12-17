//
//  Step1ViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

final class InitViewModel: ObservableObject {
    @Published var uiState: UiState = .idle

    private let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol

    init(
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol
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
        }

        do {
            try await idiomRepo.fetchRemoteData()
            try await proverbRepo.fetchRemoteData()
            try await sayingRepo.fetchRemoteData()
            try await wordRepo.fetchRemoteData()

            prefsRepo.isDataLoaded = true

            await MainActor.run {
                self.uiState = .saved
            }

            print("✅ Data fetched and saved successfully.")
        } catch {
            await MainActor.run {
                self.uiState = .error("Imefeli: \(error.localizedDescription)")
            }
            print("❌ Initialization for idioms, saying and proverbs failed: \(error)")
        }
    }
}
