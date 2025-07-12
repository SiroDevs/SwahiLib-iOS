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
                WordsList(words: viewModel.filteredWords)
                switch viewModel.homeTab {
                    case .idioms:
                    case .proverbs:
                    case .sayings:
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

struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    var onClear: (() -> Void)? = nil

    var body: some View {
        HStack {
            TextField("Tafuta ...", text: $text)
                .padding(.horizontal)
                .onChange(of: text) { newValue in
                    onSearch(newValue)
                }

            Button(action: {
                text = ""
                onSearch("")
                onClear?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.primary1)
                    .imageScale(.large)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.accent1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary1, lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}

#Preview {
    HomeView()
}
