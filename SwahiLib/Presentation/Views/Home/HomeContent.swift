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
    @State private var selectedLetter: String? = nil
    @State private var isSearching: Bool = true
    @State private var showSettings: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                SearchBar(
                    text: $searchText,
                    onSearch: { query in
                        viewModel.filterData(qry: query)
                    },
                )
                .padding(.bottom, 5)
                CustomTabTitles(
                    selectedTab: viewModel.homeTab,
                    onSelect: { homeTab in
                        viewModel.homeTab = homeTab
                        viewModel.filterData(qry: "")
                    }
                )
                .padding(.leading, 10)
                
                HStack(alignment: .top, spacing: 10) {
                    VerticalLetters(
                        selectedLetter: selectedLetter,
                        onLetterSelected: { letter in
                            selectedLetter = letter
                            viewModel.filterData(qry: letter)
                        }
                    )
                    .frame(width: 60)
                    
                    VStack {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

            }
            .padding(.vertical)
            .navigationTitle("SwahiLib - Kamusi ya Kiswahili")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .foregroundColor(.foreground1)

                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
