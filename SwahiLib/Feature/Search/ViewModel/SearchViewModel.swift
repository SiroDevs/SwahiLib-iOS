//
//  SearchViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import Foundation
import WidgetKit
import StoreKit

final class SearchViewModel: ObservableObject {
    private let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let subsRepo: SubsRepoProtocol

    @Published var isProUser: Bool = false

    @Published var searchMode: SearchMode = .beginning {
        didSet { reFilter() }
    }
    @Published var sortOrder: SortOrder = .az {
        didSet { reFilter() }
    }

    @Published var allIdioms: [Idiom] = []
    @Published var filteredIdioms: [Idiom] = []

    @Published var allProverbs: [Proverb] = []
    @Published var filteredProverbs: [Proverb] = []

    @Published var allSayings: [Saying] = []
    @Published var filteredSayings: [Saying] = []

    @Published var allWords: [Word] = []
    @Published var filteredWords: [Word] = []

    @Published var uiState: UiState = .idle
    @Published var homeTab: HomeTab = .all

    private var lastQuery: String = ""

    init(
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol,
        subsRepo: SubsRepoProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
    }

    func fetchData() {
        self.uiState = .loading("Inapakia data ...")

        Task { @MainActor in
            self.allIdioms = idiomRepo.fetchLocalData()
            self.allProverbs = proverbRepo.fetchLocalData()
            self.allSayings = sayingRepo.fetchLocalData()
            self.allWords = wordRepo.fetchLocalData()

            self.filterData(qry: "")

            subsRepo.isProUser(isOnline: false) { isActive in
                Task { @MainActor in
                    self.isProUser = isActive
                }
            }

            self.uiState = .filtered
        }
    }

    func totalResults(for tab: HomeTab) -> Int {
        switch tab {
        case .words: return filteredWords.count
        case .idioms: return filteredIdioms.count
        case .proverbs: return filteredProverbs.count
        case .sayings: return filteredSayings.count
        case .all:
            return filteredWords.count + filteredIdioms.count + filteredProverbs.count + filteredSayings.count
        }
    }

    private func reFilter() {
        filterData(qry: lastQuery)
    }

    func filterData(qry: String) {
        lastQuery = qry
        let trimmedQuery = qry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        self.uiState = .filtering

        self.filteredWords = filterAndSort(allWords, query: trimmedQuery)
        self.filteredIdioms = filterAndSort(allIdioms, query: trimmedQuery)
        self.filteredProverbs = filterAndSort(allProverbs, query: trimmedQuery)
        self.filteredSayings = filterAndSort(allSayings, query: trimmedQuery)

        self.uiState = .filtered
    }

    private func filterAndSort<T: SearchableItem>(_ items: [T], query: String) -> [T] {
        let filtered: [T]
        if query.isEmpty {
            filtered = items
        } else {
            filtered = items.filter { item in
                item.searchFields.contains { field in
                    let value = field.lowercased()
                    switch searchMode {
                    case .beginning: return value.hasPrefix(query)
                    case .middle: return value.contains(query)
                    case .end: return value.hasSuffix(query)
                    }
                }
            }
        }

        switch sortOrder {
        case .az:
            return filtered.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .za:
            return filtered.sorted { $0.title.lowercased() > $1.title.lowercased() }
        case .likedFirst:
            return filtered.sorted { lhs, rhs in
                if lhs.liked != rhs.liked { return lhs.liked && !rhs.liked }
                return lhs.title.lowercased() < rhs.title.lowercased()
            }
        }
    }
}

protocol SearchableItem {
    var title: String { get }
    var liked: Bool { get }
    var searchFields: [String] { get }
}

extension Word: SearchableItem {
    var searchFields: [String] { [title, meaning, synonyms, conjugation, english] }
}

extension Idiom: SearchableItem {
    var searchFields: [String] { [title, meaning] }
}

extension Proverb: SearchableItem {
    var searchFields: [String] { [title, meaning, synonyms, conjugation] }
}

extension Saying: SearchableItem {
    var searchFields: [String] { [title, meaning] }
}
