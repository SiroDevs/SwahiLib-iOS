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
    private let installDateKey = "installDate"
    private let usageTimeKey = "usageTime"
    private let lastPromptKey = "lastReviewPrompt"
    private var sessionStart: Date?
    
    func startSession() {
        sessionStart = Date()
    }
    
    func endSession() {
        guard let start = sessionStart else { return }
        let duration = Date().timeIntervalSince(start)
        let total = UserDefaults.standard.double(forKey: usageTimeKey) + duration
        UserDefaults.standard.set(total, forKey: usageTimeKey)
        sessionStart = nil
    }
    
    func shouldPromptReview() -> Bool {
        let installDate = UserDefaults.standard.object(forKey: installDateKey) as? Date ?? Date()
        let usageTime = UserDefaults.standard.double(forKey: usageTimeKey)
        let lastPrompt = UserDefaults.standard.object(forKey: lastPromptKey) as? Date ?? .distantPast
        
        let threeHours: TimeInterval = 3 * 60 * 60
        let eligibleByInstall = Date().timeIntervalSince(installDate) >= threeHours
        let eligibleByUsage = usageTime >= threeHours
        let eligibleByLastPrompt = Date().timeIntervalSince(lastPrompt) >= threeHours
        
        return eligibleByInstall && eligibleByUsage && eligibleByLastPrompt
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            SKStoreReviewController.requestReview(in: scene)
            UserDefaults.standard.set(Date(), forKey: lastPromptKey)
        }
    }
}
