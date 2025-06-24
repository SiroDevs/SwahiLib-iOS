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
    @Published var status: String = ""

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
        uiState = .loading

        Task {
            do {
                let idiomsResp: [Idiom] = try await idiomRepo.fetchRemoteData()
                let proverbsResp: [Proverb] = try await proverbRepo.fetchRemoteData()
                let sayingsResp: [Saying] = try await sayingRepo.fetchRemoteData()
                let wordsResp: [Word] = try await wordRepo.fetchRemoteData()

                await MainActor.run {
                    self.idioms = idiomsResp
                    self.proverbs = proverbsResp
                    self.sayings = sayingsResp
                    self.words = wordsResp
                    self.uiState = .loaded
                }
            } catch {
                await MainActor.run {
                    uiState = .error("Imefeli kupata data: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveData() {
        uiState = .saving

        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.saveIdioms() }
                group.addTask { await self.saveProverbs() }
                group.addTask { await self.saveSayings() }
                group.addTask { await self.saveWords() }
            }

            prefsRepo.isDataLoaded = true
            await MainActor.run {
                uiState = .saved
            }
        }
    }

    private func saveIdioms() async {
        await MainActor.run {
            status = "Inahifadhi nahau \(idioms.count) ..."
            progress = 0
        }

        for (index, idiom) in idioms.enumerated() {
            idiomRepo.saveData([idiom])

            let newProgress = progressPercent(current: index + 1, total: idioms.count)
            await MainActor.run {
                progress = newProgress
            }
        }
    }

    private func saveProverbs() async {
        await MainActor.run {
            status = "Inahifadhi methali \(proverbs.count) ..."
            progress = 0
        }

        for (index, proverb) in proverbs.enumerated() {
            proverbRepo.saveData([proverb])

            let newProgress = progressPercent(current: index + 1, total: proverbs.count)
            await MainActor.run {
                progress = newProgress
            }
        }
    }

    private func saveSayings() async {
        await MainActor.run {
            status = "Inahifadhi misemo \(sayings.count) ..."
            progress = 0
        }

        for (index, saying) in sayings.enumerated() {
            sayingRepo.saveData([saying])

            let newProgress = progressPercent(current: index + 1, total: sayings.count)
            await MainActor.run {
                progress = newProgress
            }
        }
    }

    private func saveWords() async {
        await MainActor.run {
            status = "Inahifadhi maneno \(words.count) ..."
            progress = 0
        }

        for (index, word) in words.enumerated() {
            wordRepo.saveData([word])

            let newProgress = progressPercent(current: index + 1, total: words.count)
            await MainActor.run {
                progress = newProgress
            }
        }
    }

    private func progressPercent(current: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(current) / Double(total)) * 100)
    }
}
