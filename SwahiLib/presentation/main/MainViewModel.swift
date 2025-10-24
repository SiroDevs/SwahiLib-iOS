//
//  MainViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation
import WidgetKit

final class MainViewModel: ObservableObject {
    private let prefsRepo: PreferencesRepository
    private let idiomRepo: IdiomRepositoryProtocol
    private let proverbRepo: ProverbRepositoryProtocol
    private let sayingRepo: SayingRepositoryProtocol
    private let wordRepo: WordRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol

    @Published var isProUser: Bool = false
    @Published var showParentalGate: Bool = false
    @Published var showReviewPrompt: Bool = false
    
    @Published var allIdioms: [Idiom] = []
    @Published var likedIdioms: [Idiom] = []
    @Published var filteredIdioms: [Idiom] = []
    
    @Published var allProverbs: [Proverb] = []
    @Published var likedProverbs: [Proverb] = []
    @Published var filteredProverbs: [Proverb] = []
    
    @Published var allSayings: [Saying] = []
    @Published var likedSayings: [Saying] = []
    @Published var filteredSayings: [Saying] = []
    
    @Published var allWords: [Word] = []
    @Published var likedWords: [Word] = []
    @Published var filteredWords: [Word] = []
    
    @Published var uiState: UiState = .idle
    @Published var homeTab: HomeTab = .words
    
    init(
        prefsRepo: PreferencesRepository,
        idiomRepo: IdiomRepositoryProtocol,
        proverbRepo: ProverbRepositoryProtocol,
        sayingRepo: SayingRepositoryProtocol,
        wordRepo: WordRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol,
        reviewRepo: ReviewReqRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
        self.reviewRepo = reviewRepo
    }
    
    func checkSubscription() {
        showParentalGate = prefsRepo.isUserAKid
        subsRepo.isProUser { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isProUser = isActive
            }
        }
    }
    
    func appDidEnterBackground() {
        reviewRepo.endSession()
        showReviewPrompt = reviewRepo.shouldPromptReview()
    }
    
    func appDidBecomeActive() {
        reviewRepo.startSession()
    }
    
    func promptReview() {
        reviewRepo.promptReview(force: false)
    }
    
    func fetchData() {
        print("Fetching data")
        self.uiState = .loading("Inapakia data ...")

        Task { @MainActor in
            self.allIdioms = idiomRepo.fetchLocalData()
            self.allProverbs = proverbRepo.fetchLocalData()
            self.allSayings = sayingRepo.fetchLocalData()
            self.allWords = wordRepo.fetchLocalData()
            
            self.checkSubscription()
            self.filterData(qry: "")
            self.uiState = .filtered
        }
    }
    
    func filterData(qry: String) {
        let trimmedQuery = qry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        print("Filtering data with query: '\(trimmedQuery)'")
        self.uiState = .filtering
        
        switch self.homeTab {
        case .idioms:
            self.likedIdioms = allIdioms.filter { $0.liked }
            self.filteredIdioms = trimmedQuery.isEmpty
                ? allIdioms
                : allIdioms.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            print("Filtered idioms: \(filteredIdioms.count)")
            
        case .sayings:
            self.likedSayings = allSayings.filter { $0.liked }
            self.filteredSayings = trimmedQuery.isEmpty
                ? allSayings
                : allSayings.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            print("Filtered sayings: \(filteredSayings.count)")
            
        case .proverbs:
            self.likedProverbs = allProverbs.filter { $0.liked }
            self.filteredProverbs = trimmedQuery.isEmpty
                ? allProverbs
                : allProverbs.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            print("Filtered proverbs: \(filteredProverbs.count)")
            
        case .words:
            self.likedWords = allWords.filter { $0.liked }
            self.filteredWords = trimmedQuery.isEmpty
                ? allWords
                : allWords.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            print("Filtered words: \(filteredWords.count)")
        }
        
        self.uiState = .filtered
    }
    
    func updateParentalGate(value: Bool) {
        prefsRepo.isUserAKid = value
        showParentalGate = value
    }
    
    func clearAllData() {
        
        print("Clearing data")
        self.uiState = .loading("Inafuta data ...")

        Task { @MainActor in
            self.idiomRepo.deleteLocalData()
            self.proverbRepo.deleteLocalData()
            self.sayingRepo.deleteLocalData()
            self.idiomRepo.deleteLocalData()
            
            prefsRepo.resetPrefs()
            self.uiState = .loaded
        }
    }
}
