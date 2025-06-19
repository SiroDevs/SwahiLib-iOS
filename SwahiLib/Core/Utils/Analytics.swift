//
//  Analytics.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//


protocol AnalyticsServiceProtocol {
    func trackEvent(_ event: String)
}

final class AnalyticsService: AnalyticsServiceProtocol {
    func trackEvent(_ event: String) {
        print("Tracked event: \(event)")
    }
}
