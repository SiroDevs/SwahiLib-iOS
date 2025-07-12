//
//  HomeContent.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct HomeContent: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var isSearching: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                if isSearching {
                    SearchBar(
                        text: $searchText,
                        onSearch: { query in
                            viewModel.filterData(query: query)
                        },
                        onClear: {
                            withAnimation {
//                                isSearching = false
                            }
                        }
                    )
                    .padding(.bottom, 5)
                }

                CustomTabTitles(
                    selectedTab: viewModel.homeTab,
                    onSelect: { book in }
                )
                .padding(.leading, 10)
                
                switch viewModel.homeTab {
                    case .idioms:
                        IdiomsList(idioms: viewModel.filteredIdioms)
                    
                    case .proverbs:
                        ProverbsList(proverbs: viewModel.filteredProverbs)
                    
                    case .sayings:
                        SayingsList(sayings: viewModel.filteredSayings)
                    
                    case .words:
                        WordsList(words: viewModel.filteredWords)
                }

            }
            .padding(.vertical)
            .navigationTitle("SwahiLib - Kamusi ya Kiswahili")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isSearching = true
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                        }
                    }
                }
        }
    }
}

#Preview {
    HomeView()
}
