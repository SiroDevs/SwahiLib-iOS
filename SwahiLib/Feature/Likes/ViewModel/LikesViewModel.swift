//
//  LikesViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/09/2026.
//
import Foundation

final class LikesViewModel: ObservableObject {
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let subsRepo: SubsRepoProtocol

    @Published var homeTab: HomeTab = .words
    @Published var likedIdioms: [Idiom] = []
    @Published var likedProverbs: [Proverb] = []
    @Published var likedSayings: [Saying] = []
    @Published var likedWords: [Word] = []
    @Published var isProUser: Bool = false

    init(
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol,
        subsRepo: SubsRepoProtocol
    ) {
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
    }

    func loadLikes() {
        likedIdioms = idiomRepo.fetchLocalData().filter { $0.liked }
        likedProverbs = proverbRepo.fetchLocalData().filter { $0.liked }
        likedSayings = sayingRepo.fetchLocalData().filter { $0.liked }
        likedWords = wordRepo.fetchLocalData().filter { $0.liked }

        subsRepo.isProUser(isOnline: false) { isActive in
            Task { @MainActor in
                self.isProUser = isActive
            }
        }
    }
}
