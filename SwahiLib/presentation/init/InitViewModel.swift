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
            let fetchedIdioms = try await idiomRepo.fetchRemoteData()
            let fetchedProverbs = try await proverbRepo.fetchRemoteData()
            let fetchedSayings = try await sayingRepo.fetchRemoteData()
            let fetchedWords = try await wordRepo.fetchRemoteData()

            await MainActor.run {
                self.idioms = fetchedIdioms
                self.proverbs = fetchedProverbs
                self.sayings = fetchedSayings
                self.words = fetchedWords
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
    
    private func saveWords() async throws {
        let batchSize = 500
        let totalWords = words.count
        
        print("📦 Saving \(totalWords) words with concurrency...")
        let startTime = Date()
        
        let batches = stride(from: 0, to: totalWords, by: batchSize).map { startIndex -> [Word] in
            let endIndex = min(startIndex + batchSize, totalWords)
            return Array(words[startIndex..<endIndex])
        }
        
        print("Created \(batches.count) batches of ~\(batchSize) words each")
        
        await withTaskGroup(of: Int.self) { group in
            let optimalConcurrency = max(1, ProcessInfo.processInfo.activeProcessorCount - 1)
            
            print("Using \(optimalConcurrency) concurrent tasks")
            
            for batchIndex in 0..<min(optimalConcurrency, batches.count) {
                let batch = batches[batchIndex]
                group.addTask {
                    let taskStart = Date()
                    for word in batch {
                        self.wordRepo.saveWord(word)
                    }
                    
                    let taskTime = Date().timeIntervalSince(taskStart)
                    print("Task \(batchIndex + 1): Saved \(batch.count) words in \(String(format: "%.2f", taskTime))s")
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
                        
                        let taskTime = Date().timeIntervalSince(taskStart)
                        print("Task \(currentIndex + 1): Saved \(batch.count) words in \(String(format: "%.2f", taskTime))s")
                        return batch.count
                    }
                }
            }
            
            print("Total words processed in tasks: \(totalSaved)")
        }
    }
}
