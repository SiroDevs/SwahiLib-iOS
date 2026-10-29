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
    /// True until the parent has passed the gate once. Drives the first screen shown.
    @Published private(set) var needsParentalGate: Bool
    /// True only for the session in which the gate was just passed (used to follow it with the paywall).
    private(set) var passedGateThisSession = false
    
    private let netUtils: NetworkUtils
    private let coreDataManager: CoreDataManager
    let prefsRepo: PrefsRepo
    private let subsRepo: SubsRepoProtocol
    
    init(
        netUtils: NetworkUtils = .shared,
        coreDataManager: CoreDataManager = .shared,
        prefsRepo: PrefsRepo,
        subsRepo: SubsRepoProtocol
    ) {
        self.netUtils = netUtils
        self.coreDataManager = coreDataManager
        self.prefsRepo = prefsRepo
        self.subsRepo = subsRepo
        self.needsParentalGate = !prefsRepo.shownParentalGate
    }
    
    func completeParentalGate() {
        prefsRepo.shownParentalGate = true
        passedGateThisSession = true
        needsParentalGate = false
    }
    
    func initialize() {
        Task {
            await loadLocalStore()

            do {
                let isOnline = await netUtils.checkNetworkAvailability()
                #if !DEBUG
                try await validateSubscription(isOnline: isOnline)
                #endif
                
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

    // Loads the Core Data store once at launch so nothing reads it before it is ready.
    private func loadLocalStore() async {
        do {
            try await coreDataManager.ensureLoaded()
        } catch {
            print("❌ Core Data failed to load: \(error.localizedDescription)")
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
