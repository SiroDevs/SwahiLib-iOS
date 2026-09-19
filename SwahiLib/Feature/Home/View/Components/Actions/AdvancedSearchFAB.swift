//
//  AdvancedSearchFAB.swift
//  SwahiLib
//
//  Created by @sirodevs on 12/09/2026.
//

import SwiftUI

struct AdvancedSearchFAB: View {
    var expanded: Bool
    var isProUser: Bool
    var prefsRepo: PrefsRepo
    @Binding var trialDialog: TrialDialogKind?

    @State private var navigate = false

    var body: some View {
        Button {
            trialDialog = TrialGate.attempt(
                .advancedSearch,
                prefsRepo: prefsRepo,
                isProUser: isProUser
            ) {
                navigate = true
            }
        } label: {
            HStack(spacing: expanded ? 8 : 0) {
                Image(systemName: "text.magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))

                if expanded {
                    Text("Tafuta kwa Kina")
                        .font(.system(size: 14, weight: .bold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .leading)))
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, expanded ? 20 : 14)
            .background(
                Capsule()
                    .fill(Color.primary2)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: expanded)
        .navigationDestination(isPresented: $navigate) {
            AdvancedSearch()
        }
    }
}
