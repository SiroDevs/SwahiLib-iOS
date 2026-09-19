//
//  TrialGate.swift
//  SwahiLib
//
//  Gates a PRO-only action for non-PRO users: the first 3 uses are free
//  (a one-time info dialog on the very first use explains this), the 4th+
//  attempt is blocked with an upgrade dialog. PRO users always pass
//  through untouched. Used for the vertical A–Z letter index, the
//  Advanced Search FAB, and sharing a word/idiom/proverb/saying.
//

import SwiftUI

enum TrialFeature: String {
    case verticalLetters
    case advancedSearch
    case share
}

enum TrialDialogKind: Identifiable {
    case firstUse
    case limitReached

    var id: Int {
        switch self {
        case .firstUse: return 0
        case .limitReached: return 1
        }
    }

    var title: String { "SwahiLib PRO" }

    var message: String {
        switch self {
        case .firstUse:
            return "Sehemu hii ni ya PRO, unaweza kutumia mara tatu kwa trial kabla kuupgrade hadi PRO."
        case .limitReached:
            return "Sehemu hii ni ya PRO, upgrade ili kuendelea kuitumia."
        }
    }
}

enum TrialGate {
    static let maxFreeUses = 3

    /// Runs `action` if the user is PRO, or still within their free trial
    /// uses for `feature`; otherwise leaves `action` untouched. Returns a
    /// dialog to show, if any — `.firstUse` alongside letting the action
    /// through (informational), `.limitReached` instead of the action
    /// (blocking).
    @discardableResult
    static func attempt(
        _ feature: TrialFeature,
        prefsRepo: PrefsRepo,
        isProUser: Bool,
        action: () -> Void
    ) -> TrialDialogKind? {
        if isProUser {
            action()
            return nil
        }

        let count = prefsRepo.trialUsageCount(for: feature)
        if count >= maxFreeUses {
            return .limitReached
        }

        prefsRepo.incrementTrialUsage(for: feature)
        action()
        return count == 0 ? .firstUse : nil
    }
}

extension View {
    /// Attaches the standard first-use / limit-reached alert pair driven
    /// by a TrialGate.attempt(...) result. `onUpgrade` is called when the
    /// person taps "Upgrade" on the limit-reached dialog — typically sets
    /// a `showPaywall` flag.
    func trialGateAlert(_ dialog: Binding<TrialDialogKind?>, onUpgrade: @escaping () -> Void) -> some View {
        self.alert(item: dialog) { kind in
            switch kind {
            case .firstUse:
                return Alert(
                    title: Text(kind.title),
                    message: Text(kind.message),
                    dismissButton: .default(Text("Sawa"))
                )
            case .limitReached:
                return Alert(
                    title: Text(kind.title),
                    message: Text(kind.message),
                    primaryButton: .default(Text("Upgrade"), action: onUpgrade),
                    secondaryButton: .cancel(Text("Ghairi"))
                )
            }
        }
    }
}
