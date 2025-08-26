//
//  HomeViewModel.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let prefsRepo: PrefsRepository
    private let idiomRepo: IdiomRepositoryProtocol
    private let proverbRepo: ProverbRepositoryProtocol
    private let sayingRepo: SayingRepositoryProtocol
    private let wordRepo: WordRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol

    @Published var isActiveSubscriber: Bool = false
    @Published var uiState: UiState = .idle
    
    init(
        prefsRepo: PrefsRepository,
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
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func promptReview() {
        reviewRepo.promptReview(force: true)
    }
    
    func checkSettings() {
        Task { @MainActor in
            self.checkSubscription()
            self.uiState = .fetched
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
            
            prefsRepo.isDataLoaded = false
            self.uiState = .loaded
        }
    }
    
    func sendEmail() {
        let subject = "SwahiLib Feedback"
        let body = "Habari, \n\nNingependa kushirikisha maoni yangu kuhusu app..."
        let email = "futuristicken@gmail.com"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
