//
//  AdvancedSearch.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import SwiftUI
import RevenueCatUI

struct AdvancedSearch: View {
    @StateObject private var viewModel: SearchViewModel = {
        DiContainer.shared.resolve(SearchViewModel.self)
    }()
    
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
                fileName: "opener-loading"
            )
            
        case .filtered:
            AdvancedSearchView(viewModel: viewModel)
            
        case .error(let msg):
            ErrorState(message: msg) {
                Task { viewModel.fetchData() }
            }
            
        default:
            LoadingState(
                title: "Inapakia data ...",
                fileName: "circle-loader"
            )
        }
    }
}

struct AdvancedSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State private var searchText: String = ""
    @State private var selectedLetter: String? = nil
    @State private var isSearching: Bool = true
    @State private var showPaywall: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        SearchBar(
                            text: $searchText,
                            onSearch: { query in
                                viewModel.filterData(qry: query)
                            }
                        )
                        .padding(.horizontal, 10)
                        
                        CustomTabTitles(
                            selectedTab: viewModel.homeTab,
                            onSelect: { homeTab in
                                viewModel.homeTab = homeTab
                                viewModel.filterData(qry: "")
                            }
                        )
                        .padding(.leading, 10)

                        AdvancedSearchBody(
                            viewModel: viewModel,
                            selectedLetter: $selectedLetter
                        )
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(displayCloseButton: true)
            }
            .navigationTitle("Tafuta kwa Kina")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}

struct AdvancedSearchBody: View {
    @ObservedObject var viewModel: SearchViewModel
    @Binding var selectedLetter: String?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VerticalLetters(
                selectedLetter: selectedLetter,
                onLetterSelected: { letter in
                    selectedLetter = letter
                    viewModel.filterData(qry: letter)
                }
            )
            .frame(width: 60)

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
