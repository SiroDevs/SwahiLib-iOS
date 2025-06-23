//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingView(title: msg!)
            case .filtering:
                ProgressView()
                    .scaleEffect(5)
                    .tint(.primary1)
            case .filtered:
                NavigationStack {
                    TabView {
                        SongsView(
                            viewModel: viewModel,
                        )
                            .tabItem {
                                Label("Songs", systemImage: "magnifyingglass")
                            }
                            .background(.accent2)
                        LikesView(viewModel: viewModel)
                            .tabItem {
                                Label("Likes", systemImage: "heart.fill")
                            }
                            .background(.accent2)
                    }
                    .navigationTitle("SwahiLib")
                }
               
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingView()
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        if case .fetched = state {
            viewModel.filterSongs(book: viewModel.books[viewModel.selectedBook].bookId)
        }
    }
    
}

struct LikesView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                SongsListView(songs: viewModel.likes)
            }
            .background(.accent1)
            .padding(.vertical)
        }
    }
}

#Preview {
    HomeView()
}
