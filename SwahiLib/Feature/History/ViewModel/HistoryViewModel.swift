//
//  HistoryViewModel.swift
//  SwahiLib
//
//  Owns the "Historia" screen: reading history (resolved to actual
//  word/idiom/proverb/saying content) and search-text history. Mirrors
//  Android's feature/history/viewmodel/HistoryViewModel.kt, minus the
//  spaced-repetition review nudge (there's no equivalent tracking on iOS
//  yet to derive it from).
//

import Foundation

struct ResolvedHistoryItem: Identifiable {
    let history: History
    let content: ContentItem?
    var id: Int { history.id }
}

final class HistoryViewModel: ObservableObject {
    private let historyData: HistoryDataManager
    private let searchData: SearchDataManager
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol

    @Published var resolvedHistory: [ResolvedHistoryItem] = []
    @Published var searchHistory: [Search] = []

    init(
        historyData: HistoryDataManager,
        searchData: SearchDataManager,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol
    ) {
        self.historyData = historyData
        self.searchData = searchData
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
    }

    func refresh() {
        refreshHistory()
        refreshSearchHistory()
    }

    func refreshHistory() {
        let words = Dictionary(uniqueKeysWithValues: wordRepo.fetchLocalData().map { ($0.rid, $0) })
        let idioms = Dictionary(uniqueKeysWithValues: idiomRepo.fetchLocalData().map { ($0.rid, $0) })
        let proverbs = Dictionary(uniqueKeysWithValues: proverbRepo.fetchLocalData().map { ($0.rid, $0) })
        let sayings = Dictionary(uniqueKeysWithValues: sayingRepo.fetchLocalData().map { ($0.rid, $0) })

        let rows = historyData.fetchHistories()
            .sorted { (Double($0.createdAt ?? "") ?? 0) > (Double($1.createdAt ?? "") ?? 0) }

        self.resolvedHistory = rows.map { h in
            let content: ContentItem?
            switch h.type {
            case "word": content = words[h.item].map { ContentItem.word($0) }
            case "idiom": content = idioms[h.item].map { ContentItem.idiom($0) }
            case "proverb": content = proverbs[h.item].map { ContentItem.proverb($0) }
            case "saying": content = sayings[h.item].map { ContentItem.saying($0) }
            default: content = nil
            }
            return ResolvedHistoryItem(history: h, content: content)
        }
    }

    func refreshSearchHistory() {
        self.searchHistory = searchData.fetchSearches()
            .sorted { (Double($0.createdAt ?? "") ?? 0) > (Double($1.createdAt ?? "") ?? 0) }
    }

    func clearReadingHistory() {
        historyData.deleteAllHistory()
        resolvedHistory = []
    }

    func clearSearchHistory() {
        searchData.deleteAllSearches()
        searchHistory = []
    }
}
