//
//  HomeSearchResults.swift
//  SwahiLib
//
//  Created by @sirodevs on 19/09/2026.
//

import SwiftUI

struct HomeSearchResults: View {
    @ObservedObject var viewModel: HomeViewModel
    var onUpgrade: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            switch viewModel.homeTab {
            case .all:
                EmptyView()

            case .words:
                SectionHeader(title: "Matokeo", count: viewModel.filteredWords.count)
                WordsList(
                    words: viewModel.filteredWords,
                    isProUser: viewModel.isProUser,
                    onUpgrade: onUpgrade
                )
                .frame(maxWidth: .infinity, alignment: .leading)

            case .idioms:
                SectionHeader(title: "Matokeo", count: viewModel.filteredIdioms.count)
                IdiomsList(
                    idioms: viewModel.filteredIdioms,
                    isProUser: viewModel.isProUser,
                    onUpgrade: onUpgrade
                )
                .frame(maxWidth: .infinity, alignment: .leading)

            case .proverbs:
                SectionHeader(title: "Matokeo", count: viewModel.filteredProverbs.count)
                ProverbsList(
                    proverbs: viewModel.filteredProverbs,
                    isProUser: viewModel.isProUser,
                    onUpgrade: onUpgrade
                )
                .frame(maxWidth: .infinity, alignment: .leading)

            case .sayings:
                SectionHeader(title: "Matokeo", count: viewModel.filteredSayings.count)
                SayingsList(
                    sayings: viewModel.filteredSayings,
                    isProUser: viewModel.isProUser,
                    onUpgrade: onUpgrade
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Color.clear.frame(height: 80)
        }
    }
}
