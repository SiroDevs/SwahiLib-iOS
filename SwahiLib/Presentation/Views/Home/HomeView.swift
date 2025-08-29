//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: MainViewModel = {
        DiContainer.shared.resolve(MainViewModel.self)
    }()
    
    private enum ActiveSheet: Identifiable {
        case parentalGate
        case paywall
        
        var id: Int { hashValue }
    }
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        stateContent
            .edgesIgnoringSafeArea(.bottom)
            .task { viewModel.fetchData() }
            .onAppear {
                if !viewModel.activeSubscriber {
                    activeSheet = .parentalGate
                }
                viewModel.promptReview()
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                    case .parentalGate:
                        ParentalGateView {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .paywall
                            }
                        }
                    case .paywall:
                        #if !DEBUG
                        PaywallView(displayCloseButton: true)
                        #endif
                }
            }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading:
            LoadingState(
                title: "Inapakia data ...",
                fileName: "opener-loading"
            )
            
        case .filtered:
            TabView {
                HomeSearch(viewModel: viewModel)
                    .tabItem {
                        Label("Tafuta", systemImage: "magnifyingglass")
                    }
                
                if viewModel.activeSubscriber {
                    HomeLikes(viewModel: viewModel)
                        .tabItem {
                            Label("Vipendwa", systemImage: "heart.fill")
                        }
                }
                
                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Label("Mipangilio", systemImage: "gear")
                    }
            }
            .environment(\.horizontalSizeClass, .compact)
            
        case .error(let msg):
            ErrorState(message: msg) {
                Task { viewModel.fetchData() }
            }
            
        default:
            LoadingState(
                title: "Inapakia data ...",
                fileName: "circle-loader"
            )
        }
    }
}
