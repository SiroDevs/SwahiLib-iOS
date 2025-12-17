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
    private let sayingRepo: SayingRepoProtocol
    private let proverbRepo: ProverbRepoProtocol

    init(
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        proverbRepo: ProverbRepoProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.sayingRepo = sayingRepo
        self.proverbRepo = proverbRepo
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
            try await sayingRepo.fetchRemoteData()
            try await proverbRepo.fetchRemoteData()

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
