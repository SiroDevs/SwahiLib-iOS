//
//  Step1ViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

final class InitViewModel: ObservableObject {
    @Published var idioms: [Idiom] = []
    @Published var proverbs: [Proverb] = []
    @Published var sayings: [Saying] = []

    @Published var uiState: UiState = .idle

    private let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol

    init(
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
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
            let fetchedIdioms = try await idiomRepo.fetchRemoteData()
            let fetchedProverbs = try await proverbRepo.fetchRemoteData()
            let fetchedSayings = try await sayingRepo.fetchRemoteData()

            await MainActor.run {
                self.idioms = fetchedIdioms
                self.proverbs = fetchedProverbs
                self.sayings = fetchedSayings
            }

            try await saveIdioms()
            try await saveProverbs()
            try await saveSayings()

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
        print("Now saving idioms")
        for (index, idiom) in idioms.enumerated() {
            idiomRepo.saveIdiom(idiom)
        }
        print("✅ Idioms saved successfully")
    }

    private func saveProverbs() async throws {
        print("Now saving proverbs")
        for (index, proverb) in proverbs.enumerated() {
            proverbRepo.saveProverb(proverb)
        }
        print("✅ Proverbs saved successfully")
    }

    private func saveSayings() async throws {
        print("Now saving sayings")
        for (index, saying) in sayings.enumerated() {
            sayingRepo.saveSaying(saying)
        }
        print("✅ Sayings saved successfully")
    }
}
