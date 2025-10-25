//
//  MainViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation
import WidgetKit
import StoreKit

final class MainViewModel: ObservableObject {
    private let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let subsRepo: SubsRepoProtocol

    @Published var isProUser: Bool = false
    @Published var userIsAKid: Bool = false
    @Published var shownParentalGate: Bool = false
    @Published var showPaywall: Bool = false
    
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
    
    func checkSubscription() {
        userIsAKid = prefsRepo.isUserAKid
        shownParentalGate = prefsRepo.shownParentalGate
        isProUser = prefsRepo.isProUser
        if !isProUser && prefsRepo.approveShowingPrompt(hours: 5) {
            showPaywall = true
        }
    }
    
    private func checkSubscription(isOnline: Bool) async throws {
        if !prefsRepo.isProUser || (isOnline) {
            try await verifySubscription(isOnline: isOnline)
        }
    }
    
    private func verifySubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    self.prefsRepo.isProUser = isActive
                    self.isProUser = isActive
                    continuation.resume()
                }
            }
        }
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
        prefsRepo.shownParentalGate = true
        shownParentalGate = true
    }
    
    func promptReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            SKStoreReviewController.requestReview(in: scene)
        }
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
