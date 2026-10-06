//
//  HomeSearch.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeSearch: View {
    @ObservedObject var viewModel: HomeViewModel
    @StateObject private var historyViewModel: HistoryViewModel = {
        DiContainer.shared.resolve(HistoryViewModel.self)
    }()
    @StateObject private var voice = VoiceSearchManager()
    @State private var searchText: String = ""
    @State private var selectedLetter: String? = nil
    @State private var isSearching: Bool = true
    @State private var showPaywall: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isAtTop: Bool = true
    @State private var trialDialog: TrialDialogKind? = nil

    private let scrollSpace = "homeSearchScroll"
    
    private var canShowReviewPrompt: Bool {
        !showPaywall
            && trialDialog == nil
            && voice.problem == nil
            && !voice.isListening
            && !viewModel.isDrawerOpen
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    text: $searchText,
                    isListening: voice.isListening,
                    onSearch: { query in
                        if query != selectedLetter { selectedLetter = nil }
                        viewModel.filterData(qry: query)
                        viewModel.trackSearch(query)
                    },
                    onVoiceSearch: {
                        selectedLetter = nil
                        voice.toggle { spoken in
                            searchText = spoken
                        }
                    }
                )
                .padding(.horizontal, 10)
                .padding(.top, 8)
                .alert(voiceAlertTitle, isPresented: showVoiceAlert) {
                    if voice.problem == .permissionDenied {
                        Button("Fungua Mipangilio") { VoiceSearchManager.openSettings() }
                        Button("Ghairi", role: .cancel) {}
                    } else {
                        Button("Sawa", role: .cancel) {}
                    }
                } message: {
                    Text(voiceAlertMessage)
                }
                .onDisappear { voice.stop() }

                CustomTabTitles(
                    selectedTab: viewModel.homeTab,
                    onSelect: { homeTab in
                        viewModel.homeTab = homeTab
                        viewModel.filterData(qry: searchText)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            scrollToTop()
                        }
                    }
                )
                .padding(.leading, 10)
                .padding(.top, 8)

                ZStack(alignment: .bottomTrailing) {
                    HStack(alignment: .top, spacing: 10) {
                        VerticalLetters(
                            selectedLetter: selectedLetter,
                            onLetterSelected: { letter in
                                trialDialog = TrialGate.attempt(
                                    .verticalLetters,
                                    prefsRepo: viewModel.prefsRepo,
                                    isProUser: viewModel.isProUser
                                ) {
                                    selectedLetter = letter
                                    searchText = letter
                                    scrollToTop()
                                }
                            }
                        )
                        .frame(width: 60)
                        .padding(.top, 12)

                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    Color.clear
                                        .frame(height: 0)
                                        .id("top")
                                        .trackScrollOffset(coordinateSpace: scrollSpace) { offset in
                                            isAtTop = offset >= -5
                                        }

                                    HomeSearchResults(viewModel: viewModel, onUpgrade: { showPaywall = true })
                                }
                                .onAppear {
                                    self.scrollViewProxy = proxy
                                }
                                .onChange(of: viewModel.homeTab) { _ in
                                    if scrollViewProxy == nil {
                                        self.scrollViewProxy = proxy
                                    }
                                }
                            }
                            .coordinateSpace(name: scrollSpace)
                        }
                    }

                    VStack(alignment: .trailing, spacing: 10) {
                        if !isAtTop {
                            ScrollToTopButton {
                                withAnimation {
                                    scrollToTop()
                                }
                            }
                            .transition(.opacity)
                        }

                        AdvancedSearchFAB(
                            expanded: isAtTop,
                            isProUser: viewModel.isProUser,
                            prefsRepo: viewModel.prefsRepo,
                            trialDialog: $trialDialog
                        )
                    }
                    .animation(.easeInOut(duration: 0.2), value: isAtTop)
                    .padding()
                }
            }
            .trialGateAlert($trialDialog, onUpgrade: { showPaywall = true })
            .sheet(isPresented: $showPaywall) {
                PaywallView(displayCloseButton: true)
            }
            .navigationTitle("SwahiLib")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text("SwahiLib")
                            .font(.headline)
                        Text("Kamusi ya Kiswahili")
                            .font(.caption)
                            .foregroundColor(Color.onPrimaryContainer.opacity(0.7))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.isDrawerOpen = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        LikesView()
                    } label: {
                        Image(systemName: "heart.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        HistoryScreen(
                            viewModel: historyViewModel,
                            onSearchSelected: { query in
                                selectedLetter = nil
                                searchText = query
                                viewModel.filterData(qry: query)
                            }
                        )
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .reviewPrompt(isEnabled: canShowReviewPrompt)
        }
    }
    
    private func scrollToTop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy?.scrollTo("top", anchor: .top)
        }
    }

    private var showVoiceAlert: Binding<Bool> {
        Binding(
            get: { voice.problem != nil },
            set: { if !$0 { voice.problem = nil } }
        )
    }

    private var voiceAlertTitle: String {
        voice.problem == .permissionDenied ? "Ruhusa Inahitajika" : "Utafutaji kwa Sauti"
    }

    private var voiceAlertMessage: String {
        voice.problem == .permissionDenied
            ? "Ruhusu Maikrofoni na Utambuzi wa Usemi kwenye Mipangilio ili kutafuta kwa sauti."
            : "Utafutaji kwa sauti haupatikani kwa sasa. Jaribu tena baadaye."
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
