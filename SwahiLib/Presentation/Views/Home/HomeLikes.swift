//
//  HomeLikes.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct HomeLikes: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
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
                        case .idioms:
                            IdiomsList(idioms: viewModel.likedIdioms)
                        case .proverbs:
                            ProverbsList(proverbs: viewModel.likedProverbs)
                        case .sayings:
                            SayingsList(sayings: viewModel.likedSayings)
                        case .words:
                            WordsList(words: viewModel.likedWords)
                    }
                }
            }
            .padding(.vertical)
            .navigationTitle("Vipendwa")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
