//
//  LikesView.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI
import RevenueCatUI

struct LikesView: View {
    @StateObject private var viewModel: LikesViewModel = {
        DiContainer.shared.resolve(LikesViewModel.self)
    }()

    @State private var showPaywall: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                CustomTabTitles(
                    selectedTab: viewModel.homeTab,
                    onSelect: { homeTab in
                        viewModel.homeTab = homeTab
                    }
                )
                .padding(.leading, 10)

                switch viewModel.homeTab {
                    case .all:
                        EmptyView()
                    case .idioms:
                        IdiomsList(idioms: viewModel.likedIdioms, isProUser: viewModel.isProUser, onUpgrade: { showPaywall = true })
                    case .proverbs:
                        ProverbsList(proverbs: viewModel.likedProverbs, isProUser: viewModel.isProUser, onUpgrade: { showPaywall = true })
                    case .sayings:
                        SayingsList(sayings: viewModel.likedSayings, isProUser: viewModel.isProUser, onUpgrade: { showPaywall = true })
                    case .words:
                        WordsList(words: viewModel.likedWords, isProUser: viewModel.isProUser, onUpgrade: { showPaywall = true })
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .padding(.vertical)
        .navigationTitle("Vipendwa")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .onAppear {
            viewModel.loadLikes()
        }
    }
}
