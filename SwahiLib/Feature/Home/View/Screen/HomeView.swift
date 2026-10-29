//
//  HomeView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    @StateObject private var libraryViewModel: LibraryViewModel = {
        DiContainer.shared.resolve(LibraryViewModel.self)
    }()
    
    /// Set by the splash flow right after a first-time user passes the parental gate.
    var showPaywallOnLaunch: Bool = false
    
    @State private var showPaywall = false
    @State private var launchPromptHandled = false
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onAppear {
            #if !DEBUG
            guard !launchPromptHandled else { return }
            launchPromptHandled = true
            if !viewModel.isProUser
                && (showPaywallOnLaunch || viewModel.prefsRepo.approveShowingPrompt(hours: 5)) {
                showPaywall = true
            }
            #endif
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .fullScreenCover(item: $viewModel.homeDestination) { destination in
            NavigationStack {
                switch destination {
                case .dailyWord:
                    DailyWordScreen()
                case .dailyProverb:
                    DailyProverbScreen()
                case .settings:
                    SettingsView(viewModel: viewModel)
                }
            }
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                HomeSkeleton()
                
            case .filtered:
                ZStack(alignment: .leading) {
                    TabView {
                        HomeSearch(viewModel: viewModel)
                            .tabItem {
                                Label("Tafuta", systemImage: "magnifyingglass")
                            }
                        
                        LibraryView(viewModel: libraryViewModel, homeViewModel: viewModel)
                            .tabItem {
                                Label("Maktaba", systemImage: "books.vertical.fill")
                            }
                    }
                    .environment(\.horizontalSizeClass, .compact)

                    NavDrawer(isOpen: $viewModel.isDrawerOpen) { destination in
                        viewModel.homeDestination = destination
                    }
                }
                
            case .error(let msg):
                ErrorState(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                HomeSkeleton()
        }
    }
}
