//
//  ReviewRequestRepository.swift
//  SwahiLib
//
//  Created by Siro Daves on 25/08/2025.
//

import StoreKit

protocol ReviewReqRepositoryProtocol {
    func startSession()
    func endSession()
    func shouldPromptReview() -> Bool
    func requestReview()
}

final class ReviewReqRepository: ReviewReqRepositoryProtocol {
    private var sessionStart: Date?
    private let prefs: PrefsRepository
    
    init(prefs: PrefsRepository = PrefsRepository()) {
        self.prefs = prefs
        if prefs.installDate == Date() {
            prefs.installDate = Date()
        }
    }
    
    func startSession() {
        sessionStart = Date()
    }
    
    func endSession() {
        guard let start = sessionStart else { return }
        let duration = Date().timeIntervalSince(start)
        prefs.usageTime += duration
        sessionStart = nil
    }
    
    func shouldPromptReview() -> Bool {
        guard !prefs.reviewRequested else { return false } // Already done
        
        let threeHours: TimeInterval = 3 * 60 * 60
        let eligibleByInstall = Date().timeIntervalSince(prefs.installDate) >= threeHours
        let eligibleByUsage = prefs.usageTime >= threeHours
        let eligibleByLastPrompt = Date().timeIntervalSince(prefs.lastReviewPrompt) >= threeHours
        
        return eligibleByInstall && eligibleByUsage && eligibleByLastPrompt
    }
    
    func requestReview() {
        guard shouldPromptReview() else { return }
        
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            SKStoreReviewController.requestReview(in: scene)
            prefs.lastReviewPrompt = Date()
            prefs.reviewRequested = true
        }
    }
}
