//
//  SettingsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/08/2025.
//
//  Presented from HomeView as a fullScreenCover (wrapped in a fresh
//  NavigationStack there) rather than pushed onto a shared stack spanning
//  the whole TabView — that was tried and reverted, since nesting a
//  NavigationStack inside another one (even through a TabView) makes
//  SwiftUI drop the inner stacks' navigation bars, which broke Home
//  Search's and Maktaba's title bars. This view has no NavigationStack of
//  its own (the fullScreenCover call site provides one) and uses a
//  back-chevron button rather than a "Funga"/close button so it still
//  reads as a normal screen.

import SwiftUI
import RevenueCatUI

struct SettingsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showPaywall: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var restartTheApp = false

    var body: some View {
        Group {
            if restartTheApp {
                SplashView(deepLinked: false, word: Word.sampleWords[0])
            } else {
                mainContent
            }
        }
    }

    private var mainContent: some View {
        SettingsForm(
            viewModel: viewModel,
            showPaywall: $showPaywall,
            showResetAlert: $showResetAlert
        )
        .alert(L10n.resetDataAlert, isPresented: $showResetAlert) {
            Button(L10n.cancel, role: .cancel) { }
            Button(L10n.okay, role: .destructive) {
                viewModel.clearAllData()
            }
        } message: {
            Text(L10n.resetDataAlertDesc)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .navigationTitle("Mipangilio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }
}
