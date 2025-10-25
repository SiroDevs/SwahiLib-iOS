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
    private let netUtils: NetworkUtils
    let prefsRepo: PrefsRepo
    private let subsRepo: SubsRepoProtocol
    
    @Published var isInitialized = false

    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PrefsRepo,
        subsRepo: SubsRepoProtocol,
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.subsRepo = subsRepo
    }
    
    func initialize() {
        Task { @MainActor in
            do {
                let isOnline = await netUtils.checkNetworkAvailability()
                try await checkSubscription(isOnline: isOnline)
            } catch {
                print("Subscription check failed: \(error)")
            }
            prefsRepo.updateAppOpenTime()
            isInitialized = true
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
                    continuation.resume()
                }
            }
        }
    }
}
