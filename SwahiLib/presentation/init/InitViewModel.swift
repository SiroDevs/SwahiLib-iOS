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
    @Published var words: [Word] = []

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
            async let fetchedIdiomsTask = idiomRepo.fetchRemoteData()
            async let fetchedProverbsTask = proverbRepo.fetchRemoteData()
            async let fetchedSayingsTask = sayingRepo.fetchRemoteData()
            async let fetchedWordsTask = wordRepo.fetchRemoteData()

            let (fetchedIdioms, fetchedProverbs, fetchedSayings, fetchedWords) = try await (
                fetchedIdiomsTask,
                fetchedProverbsTask,
                fetchedSayingsTask,
                fetchedWordsTask
            )
            
            await MainActor.run {
                self.idioms = fetchedIdioms
                self.proverbs = fetchedProverbs
                self.sayings = fetchedSayings
                self.words = fetchedWords
            }

            try saveIdioms()
            try saveProverbs()
            try saveSayings()
            try await saveWords()

            prefsRepo.isDataLoaded = true

            await MainActor.run {
                self.uiState = .saved
            }
        } catch {
            await MainActor.run {
                self.uiState = .error("Imefeli: \(error.localizedDescription)")
            }
            print("❌ Initialization failed: \(error)")
        }
    }


    private func saveIdioms() throws {
        for idiom in idioms {
            idiomRepo.saveIdiom(idiom)
        }
    }

    private func saveProverbs() throws {
        for proverb in proverbs {
            proverbRepo.saveProverb(proverb)
        }
    }

    private func saveSayings() throws {
        for saying in sayings {
            sayingRepo.saveSaying(saying)
        }
    }
    
    private func saveWords() async throws {
        let batchSize = 500
        let totalWords = words.count
        
        let batches = stride(from: 0, to: totalWords, by: batchSize).map { startIndex -> [Word] in
            let endIndex = min(startIndex + batchSize, totalWords)
            return Array(words[startIndex..<endIndex])
        }
        
        await withTaskGroup(of: Int.self) { group in
            let optimalConcurrency = max(1, ProcessInfo.processInfo.activeProcessorCount - 1)
            
            for batchIndex in 0..<min(optimalConcurrency, batches.count) {
                let batch = batches[batchIndex]
                group.addTask {
                    let taskStart = Date()
                    for word in batch {
                        self.wordRepo.saveWord(word)
                    }
                    return batch.count
                }
            }
            
            var nextBatchIndex = optimalConcurrency
            var totalSaved = 0
            
            for await result in group {
                totalSaved += result
                
                if nextBatchIndex < batches.count {
                    let batch = batches[nextBatchIndex]
                    let currentIndex = nextBatchIndex
                    nextBatchIndex += 1
                    
                    group.addTask {
                        let taskStart = Date()
                        
                        for word in batch {
                            self.wordRepo.saveWord(word)
                        }
                        return batch.count
                    }
                }
            }
        }
    }
}
