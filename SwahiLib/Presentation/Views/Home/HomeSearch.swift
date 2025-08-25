//
//  HomeSearch.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct HomeSearch: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var selectedLetter: String? = nil
    @State private var isSearching: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    SearchBar(
                        text: $searchText,
                        onSearch: { query in
                            viewModel.filterData(qry: query)
                        }
                    )
                    
                    CustomTabTitles(
                        selectedTab: viewModel.homeTab,
                        onSelect: { homeTab in
                            viewModel.homeTab = homeTab
                            viewModel.filterData(qry: "")
                        }
                    )
                    .padding(.leading, 10)

                    HomeSearchView(
                        viewModel: viewModel,
                        selectedLetter: $selectedLetter
                    )
                }
            }
            .navigationTitle("SwahiLib")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}

struct HomeSearchView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedLetter: String?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if viewModel.isActiveSubscriber {
                VerticalLetters(
                    selectedLetter: selectedLetter,
                    onLetterSelected: { letter in
                        selectedLetter = letter
                        viewModel.filterData(qry: letter)
                    }
                )
                .frame(width: 60)
            }

            switch viewModel.homeTab {
                case .idioms:
                    IdiomsList(idioms: viewModel.filteredIdioms)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                case .proverbs:
                    ProverbsList(proverbs: viewModel.filteredProverbs)
                        .frame(maxWidth: .infinity, alignment: .leading)
                case .sayings:
                    SayingsList(sayings: viewModel.filteredSayings)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                case .words:
                    WordsList(words: viewModel.filteredWords)
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    HStack(alignment: .top, spacing: 10) {
        VerticalLetters(
            selectedLetter: "A",
            onLetterSelected: { letter in
                //
            }
        )
        .frame(width: 60)
        WordsList(
            words: Word.sampleWords
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
