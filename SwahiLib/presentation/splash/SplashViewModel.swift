//
//  SplashViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import Foundation
import SwiftUI
import Network

final class SplashViewModel: ObservableObject {
    @Published var isInitialized = false
    @Published var isProUser: Bool = false
    
    private let netUtils: NetworkUtils
    let prefsRepo: PrefsRepo
    private let subsRepo: SubsRepoProtocol
    private let wordRepo: WordRepoProtocol
    
    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PrefsRepo,
        subsRepo: SubsRepoProtocol,
        wordRepo: WordRepoProtocol
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.subsRepo = subsRepo
        self.wordRepo = wordRepo
    }
    
    func initialize() {
        Task {
            do {
                let isOnline = await netUtils.checkNetworkAvailability()
                
                // Convert callback to async/await properly
                #if !DEBUG
                try await validateSubscription(isOnline: isOnline)
                #endif
                
                try await wordRepo.fetchRemoteData()
                
                prefsRepo.updateAppOpenTime()
                
                await MainActor.run {
                    isInitialized = true
                }
            } catch {
                print("Initialization failed: \(error)")
                await MainActor.run {
                    isInitialized = true
                }
            }
        }
    }

    private func validateSubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    self.isProUser = isActive
                    continuation.resume()
                }
            }
        }
    }
}
