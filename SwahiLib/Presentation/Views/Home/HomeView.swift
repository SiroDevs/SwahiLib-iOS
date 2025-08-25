//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    @State private var showSettings: Bool = false
    @State private var showPaywall: Bool = false
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "opener-loading",
                )
            
            case .filtered:
                TabView {
                    HomeSearch(viewModel: viewModel)
                        .tabItem {
                            Label("Tafuta", systemImage: "magnifyingglass")
                        }
                    
                    if viewModel.isActiveSubscriber {
                        HomeLikes(viewModel: viewModel)
                            .tabItem {
                                Label("Vipendwa", systemImage: "heart.fill")
                            }
                    }
                    SettingsView()
                        .tabItem {
                            Label("Mipangilio", systemImage: "gear")
                        }
                }
                .onAppear {
                    #if !DEBUG
                        showPaywall = true
                    #endif
                    viewModel.requestReview()
                }
                .sheet(isPresented: $showPaywall) {
                    #if !DEBUG
                        PaywallView(displayCloseButton: true)
                    #endif
                }
               
            case .error(let msg):
                ErrorState(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "circle-loader",
                )
        }
    }
}
