//
//  ReviewPrompt.swift
//  SongLib
//
//  Created by @sirodevs on 05/10/2026.

import SwiftUI
import StoreKit

struct ReviewPromptConfig {
    var initialDelay: TimeInterval = 48 * 60 * 60
    var reminderDelay: TimeInterval = 48 * 60 * 60
    var presentationDelay: TimeInterval = 2
    var keyPrefix = "reviewPrompt"
}

@MainActor
final class ReviewPromptManager: ObservableObject {
    static let shared = ReviewPromptManager()

    enum Step { case enjoying, review }

    @Published fileprivate(set) var step: Step?

    private(set) var config: ReviewPromptConfig
    private let defaults: UserDefaults

    private var startedThisSession = false

    private enum Key: String {
        case firstLaunchDate, lastDeferredDate, isHandled
    }

    private func key(_ key: Key) -> String { "\(config.keyPrefix).\(key.rawValue)" }

    init(defaults: UserDefaults = .standard, config: ReviewPromptConfig = ReviewPromptConfig()) {
        self.defaults = defaults
        self.config = config
        recordFirstLaunchIfNeeded()
    }

    func configure(_ config: ReviewPromptConfig = ReviewPromptConfig()) {
        self.config = config
        recordFirstLaunchIfNeeded()
    }

    private func recordFirstLaunchIfNeeded() {
        guard defaults.object(forKey: key(.firstLaunchDate)) == nil else { return }
        defaults.set(Date().timeIntervalSince1970, forKey: key(.firstLaunchDate))
    }

    private var isHandled: Bool { defaults.bool(forKey: key(.isHandled)) }

    private func date(for key: Key) -> Date? {
        guard let seconds = defaults.object(forKey: self.key(key)) as? Double else { return nil }
        return Date(timeIntervalSince1970: seconds)
    }

    private func isEligible(now: Date = Date()) -> Bool {
        guard !isHandled, let firstLaunch = date(for: .firstLaunchDate) else { return false }
        guard now.timeIntervalSince(firstLaunch) >= config.initialDelay else { return false }
        if let deferred = date(for: .lastDeferredDate),
           now.timeIntervalSince(deferred) < config.reminderDelay {
            return false
        }
        return true
    }

    func startIfEligible() {
        guard step == nil, !startedThisSession, isEligible() else { return }
        startedThisSession = true
        step = .enjoying
    }

    fileprivate func answerEnjoying() {
        step = nil
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            step = .review
        }
    }

    fileprivate func reviewNow() {
        defaults.set(true, forKey: key(.isHandled))
        step = nil
    }

    fileprivate func later() {
        defaults.set(Date().timeIntervalSince1970, forKey: key(.lastDeferredDate))
        step = nil
    }

    #if DEBUG
    func debugReset() {
        [Key.firstLaunchDate, .lastDeferredDate, .isHandled].forEach { defaults.removeObject(forKey: key($0)) }
        startedThisSession = false
        step = nil
        recordFirstLaunchIfNeeded()
    }
    #endif
}

private struct ReviewPromptModifier: ViewModifier {
    @ObservedObject private var manager = ReviewPromptManager.shared
    @Environment(\.requestReview) private var requestReview

    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .task(id: isEnabled) {
                guard isEnabled else { return }
                try? await Task.sleep(nanoseconds: UInt64(manager.config.presentationDelay * 1_000_000_000))
                guard !Task.isCancelled else { return }
                manager.startIfEligible()
            }
            .alert(
                manager.step == .review ? "Would you leave a review?" : "Are you enjoying the app?",
                isPresented: Binding(get: { manager.step != nil }, set: { _ in }),
                presenting: manager.step
            ) { step in
                switch step {
                case .enjoying:
                    Button("Yes") { manager.answerEnjoying() }
                    Button("No") { manager.answerEnjoying() }
                case .review:
                    Button("Review Now") {
                        manager.reviewNow()
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            requestReview()
                        }
                    }
                    Button("Later", role: .cancel) { manager.later() }
                }
            } message: { step in
                if step == .review {
                    Text("A quick rating helps other people find the app.")
                }
            }
    }
}

extension View {
    func reviewPrompt(isEnabled: Bool = true) -> some View {
        modifier(ReviewPromptModifier(isEnabled: isEnabled))
    }
}
