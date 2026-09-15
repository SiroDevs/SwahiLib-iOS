//
//  LibraryCollectionsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Now carries the same hamburger/history/likes toolbar HomeSearch has,
//  so both tabs offer the same menus.

import SwiftUI

struct LibraryCollectionsView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @StateObject private var historyViewModel: HistoryViewModel = {
        DiContainer.shared.resolve(HistoryViewModel.self)
    }()

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.collections) { config in
                        NavigationLink {
                            LibraryDetailView(viewModel: viewModel, collectionKey: config.key)
                        } label: {
                            LibraryTileCard(config: config)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Maktaba")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            homeViewModel.isDrawerOpen = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        HistoryScreen(
                            viewModel: historyViewModel,
                            onSearchSelected: { _ in }
                        )
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        LikesView()
                    } label: {
                        Image(systemName: "heart.fill")
                    }
                }
            }
        }
    }
}
