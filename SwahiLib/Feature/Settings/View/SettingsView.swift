//
//  SettingsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/08/2025.
//

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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showResetAlert = true
                    } label: {
                        Label(L10n.resetData, systemImage: "exclamationmark.triangle.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.primary1)
                }
            }
        }
    }
}
