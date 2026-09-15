//
//  DailyContentViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import Foundation

struct DailyContentHistoryEntry: Identifiable {
    let content: DailyContent
    let word: Word?
    let proverb: Proverb?
    var id: String { content.date }
}

final class DailyContentViewModel: ObservableObject {
    private let dailyContentData: DailyContentDataManager
    private let wordRepo: WordRepoProtocol
    private let proverbRepo: ProverbRepoProtocol

    @Published var dailyWord: Word?
    @Published var dailyWordMeaning: String = ""
    @Published var dailyProverb: Proverb?
    @Published var dailyProverbMeaning: String = ""
    @Published var history: [DailyContentHistoryEntry] = []
    @Published var uiState: UiState = .idle

    private var historyLoaded = false

    init(
        dailyContentData: DailyContentDataManager,
        wordRepo: WordRepoProtocol,
        proverbRepo: ProverbRepoProtocol
    ) {
        self.dailyContentData = dailyContentData
        self.wordRepo = wordRepo
        self.proverbRepo = proverbRepo
    }

    func loadDailyContent() {
        uiState = .loading(nil)

        let words = wordRepo.fetchLocalData()
        let proverbs = proverbRepo.fetchLocalData()
        let today = dailyContentData.getOrCreateToday(words: words, proverbs: proverbs)

        dailyWord = words.first { $0.rid == today.wordRid }
        dailyWordMeaning = today.wordMeaning
        dailyProverb = proverbs.first { $0.rid == today.proverbRid }
        dailyProverbMeaning = today.proverbMeaning

        uiState = .loaded
    }

    /// Loads the full daily-content history once; safe to call from every
    /// entry point (Daily Word screen, Daily Proverb screen).
    func loadHistory() {
        guard !historyLoaded else { return }
        historyLoaded = true

        let words = wordRepo.fetchLocalData().keyedByID { ($0.rid, $0) }
        let proverbs = proverbRepo.fetchLocalData().keyedByID { ($0.rid, $0) }

        history = dailyContentData.fetchAll().map { content in
            DailyContentHistoryEntry(
                content: content,
                word: words[content.wordRid],
                proverb: proverbs[content.proverbRid]
            )
        }
    }

    func clearHistory() {
        dailyContentData.clearAll()
        history = []
        historyLoaded = false
    }
}
