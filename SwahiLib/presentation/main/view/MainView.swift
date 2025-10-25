//
//  MainView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = {
        DiContainer.shared.resolve(MainViewModel.self)
    }()
    
    private enum ActiveSheet: Identifiable {
        case showParentalGate
        case showPaywall
        
        var id: Int { hashValue }
    }
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        stateContent
            .edgesIgnoringSafeArea(.bottom)
            .task { viewModel.fetchData() }
            .onAppear {
                if !viewModel.isProUser && viewModel.userIsAKid && !viewModel.shownParentalGate {
                    activeSheet = .showParentalGate
                } else if !viewModel.isProUser && viewModel.shownParentalGate{
                    activeSheet = .showPaywall
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                    case .showParentalGate:
                        ParentalGateView {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.updateParentalGate(value: true)
                                activeSheet = .showPaywall
                            }
                        }
                    case .showPaywall:
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
                
                HomeLikes(viewModel: viewModel)
                    .tabItem {
                        Label("Vipendwa", systemImage: "heart.fill")
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
