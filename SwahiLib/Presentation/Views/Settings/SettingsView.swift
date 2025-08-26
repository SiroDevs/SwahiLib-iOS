//
//  SettingsView.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = {
        DiContainer.shared.resolve(SettingsViewModel.self)
    }()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showPaywall: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var restartTheApp = false
    
    var body: some View {
        Group {
            if restartTheApp {
                AnyView(SplashView())
            } else {
                AnyView(mainContent)
            }
        }
    }
    
    var mainContent: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.checkSettings() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .fetched:
                NavigationStack {
                    Form {
                        ThemeSectionView(
                            selectedTheme: $themeManager.selectedTheme
                        )
                        
                        #if !DEBUG
                        if !viewModel.isActiveSubscriber {
                            ProSectionView { showPaywall = true }
                        }
                        #endif
                        
                        ReviewSectionView(
                            onReview: viewModel.promptReview,
                            onEmail: viewModel.sendEmail
                        )
                        
                        ResetSectionView { showResetAlert = true }
                    }
                    .alert(L10n.resetData, isPresented: $showResetAlert) {
                        Button(L10n.cancel, role: .cancel) { }
                        Button(L10n.okay, role: .destructive) {
                            viewModel.clearAllData()
                        }
                    } message: {
                        Text(L10n.resetDataDesc)
                    }
                    .sheet(isPresented: $showPaywall) {
                        PaywallView(displayCloseButton: true)
                    }
                    .navigationTitle("Mipangilio")
                    .toolbarBackground(.regularMaterial, for: .navigationBar)
                }
               
            case .error(let msg):
                ErrorState(message: msg) { }
                
            default:
                LoadingState()
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        restartTheApp = .loaded == state
    }
}

#Preview {
    SettingsView()
}
