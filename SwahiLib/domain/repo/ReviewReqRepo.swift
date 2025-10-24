//
//  ReviewRequestRepository.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/08/2025.
//

import StoreKit

protocol ReviewReqRepoProtocol {
    func startSession()
    func endSession()
    func shouldPromptReview() -> Bool
    func promptReview(force: Bool)
}

final class ReviewReqRepo: ReviewReqRepoProtocol {
    private var sessionStart: Date?
    private let prefsRepo: PrefsRepo
    
    init(prefsRepo: PrefsRepo = PrefsRepo()) {
        self.prefsRepo = prefsRepo
        if prefsRepo.installDate == Date() {
            prefsRepo.installDate = Date()
        }
    }
    
    func startSession() {
        sessionStart = Date()
    }
    
    func endSession() {
        guard let start = sessionStart else { return }
        let duration = Date().timeIntervalSince(start)
        prefsRepo.usageTime += duration
        sessionStart = nil
    }
    
    func shouldPromptReview() -> Bool {
        guard !prefsRepo.reviewRequested else { return false } // Already done
        
        let threeHours: TimeInterval = 3 * 60 * 60
        let eligibleByInstall = Date().timeIntervalSince(prefsRepo.installDate) >= threeHours
        let eligibleByUsage = prefsRepo.usageTime >= threeHours
        let eligibleByLastPrompt = Date().timeIntervalSince(prefsRepo.lastReviewPrompt) >= threeHours
        
        return eligibleByInstall && eligibleByUsage && eligibleByLastPrompt
    }
    
    func promptReview(force: Bool = false) {
        guard force || shouldPromptReview() else { return }
        
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            SKStoreReviewController.requestReview(in: scene)
            prefsRepo.lastReviewPrompt = Date()
            prefsRepo.reviewRequested = true
        }
    }

}
