//
//  ShareFAB.swift
//  SwahiLib
//
//  Sharing moved from a toolbar ShareLink to a floating action button,
//  gated the same way as the vertical letters and Advanced Search: 3 free
//  uses, then an upgrade dialog. ShareLink itself has no way to intercept
//  the tap before it opens the share sheet, so this wraps
//  UIActivityViewController directly to keep the gate check in front of it.
//

import SwiftUI
import UIKit

struct ActivityShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ShareFAB: View {
    let shareText: String
    let isProUser: Bool
    let prefsRepo: PrefsRepo
    @Binding var trialDialog: TrialDialogKind?

    @State private var showShareSheet = false

    var body: some View {
        Button {
            trialDialog = TrialGate.attempt(
                .share,
                prefsRepo: prefsRepo,
                isProUser: isProUser
            ) {
                showShareSheet = true
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(Color.primary2)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding()
        .sheet(isPresented: $showShareSheet) {
            ActivityShareSheet(items: [shareText])
        }
    }
}
