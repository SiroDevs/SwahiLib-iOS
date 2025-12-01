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

    @Published var showAlertDialog: Bool = false
    @Published var isProUser: Bool = false
    
    @Published var searchPart: SearchOptionsParts = .byTitle
    @Published var searchPattern: SearchOptionsPatterns = .beginning
        
    @Published var allIdioms: [Idiom] = []
    @Published var filteredIdioms: [Idiom] = []
    
    @Published var allProverbs: [Proverb] = []
    @Published var filteredProverbs: [Proverb] = []
    
    @Published var allSayings: [Saying] = []
    @Published var filteredSayings: [Saying] = []
    
    @Published var allWords: [Word] = []
    @Published var filteredWords: [Word] = []
    
    @Published var uiState: UiState = .idle
    @Published var homeTab: HomeTab = .words
    
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
    
    func fetchData() {
        print("Fetching data")
        self.uiState = .loading("Inapakia data ...")

        Task { @MainActor in
            self.allIdioms = idiomRepo.fetchLocalData()
            self.allProverbs = proverbRepo.fetchLocalData()
            self.allSayings = sayingRepo.fetchLocalData()
            self.allWords = wordRepo.fetchLocalData()
            
            self.filterData(qry: "")
            self.uiState = .filtered
        }
    }
    
    func filterData(qry: String) {
        let trimmedQuery = qry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        self.uiState = .filtering
        
        switch self.homeTab {
        case .idioms:
            self.filteredIdioms = filterItems(items: allIdioms, query: trimmedQuery)
        case .sayings:
            self.filteredSayings = filterItems(items: allSayings, query: trimmedQuery)
        case .proverbs:
            self.filteredProverbs = filterItems(items: allProverbs, query: trimmedQuery)
        case .words:
            self.filteredWords = filterItems(items: allWords, query: trimmedQuery)
        }
        
        self.uiState = .filtered
    }
    
    private func filterItems<T: SearchableItem>(items: [T], query: String) -> [T] {
        guard !query.isEmpty else { return items }
        
        return items.filter { item in
            let searchText: String
            
            switch searchPart {
            case .byTitle:
                searchText = item.title.lowercased()
            case .byMeaning:
                if let meanings = item.meanings {
                    searchText = meanings.joined(separator: " ").lowercased()
                } else {
                    searchText = item.title.lowercased()
                }
            }
            
            switch searchPattern {
            case .beginning:
                return searchText.hasPrefix(query)
            case .middle:
                return searchText.contains(query)
            case .end:
                return searchText.hasSuffix(query)
            }
        }
    }
}

protocol SearchableItem {
    var title: String { get }
    var meanings: [String]? { get }
}

extension Idiom: SearchableItem {
    var meanings: [String]? {
        return []
    }
}

extension Proverb: SearchableItem {
    var meanings: [String]? {
        return []
    }
}

extension Saying: SearchableItem {
    var meanings: [String]? {
        return []
    }
}

extension Word: SearchableItem {
    var meanings: [String]? {
        return []
    }
}
