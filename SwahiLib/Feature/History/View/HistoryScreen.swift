//
//  HistoryScreen.swift
//  SwahiLib
//
//  Mirrors Android's feature/history/view/HistoryScreen.kt (minus the
//  spaced-repetition review nudge — there's no tracking on iOS yet to
//  derive it from).
//

import SwiftUI

private enum HistoryChip: String, CaseIterable {
    case usomaji = "USOMAJI"
    case utafutaji = "UTAFUTAJI"
}

struct HistoryScreen: View {
    @ObservedObject var viewModel: HistoryViewModel
    /// Hands a tapped search-history row back to Home's search field, then
    /// pops this screen — mirrors Android's savedStateHandle bridge back to
    /// HomeSearch.
    var onSearchSelected: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedChip: HistoryChip = .usomaji
    @State private var showClearConfirm = false

    private var hasContent: Bool {
        !viewModel.resolvedHistory.isEmpty || !viewModel.searchHistory.isEmpty
    }

    private var hasCurrentTabContent: Bool {
        switch selectedChip {
        case .usomaji: return !viewModel.resolvedHistory.isEmpty
        case .utafutaji: return !viewModel.searchHistory.isEmpty
        }
    }

    var body: some View {
        Group {
            if !hasContent {
                EmptyState(
                    title: "Hamna Historia",
                    message: "Anza kutazama maneno, nahau, misemo, methali au pia kutafuta.",
                    systemImage: "clock.arrow.circlepath"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4, pinnedViews: [.sectionHeaders]) {
                        Section {
                            switch selectedChip {
                            case .usomaji:
                                readingsSection
                            case .utafutaji:
                                searchesSection
                            }
                        } header: {
                            chipRow
                        }

                        Color.clear.frame(height: 24)
                    }
                }
            }
        }
        .navigationTitle("Historia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .toolbar {
            if hasCurrentTabContent {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showClearConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert(
            selectedChip == .usomaji ? "Futa Historia ya Usomaji?" : "Futa Historia ya Utafutaji?",
            isPresented: $showClearConfirm
        ) {
            Button("Futa", role: .destructive) {
                switch selectedChip {
                case .usomaji: viewModel.clearReadingHistory()
                case .utafutaji: viewModel.clearSearchHistory()
                }
            }
            Button("Ghairi", role: .cancel) {}
        } message: {
            Text(
                selectedChip == .usomaji
                    ? "Utaondoa maneno, nahau, misemo na methali ulizoangalia hivi karibuni."
                    : "Utaondoa maneno uliyotafuta hivi karibuni."
            )
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private var chipRow: some View {
        HStack(spacing: 8) {
            ForEach(HistoryChip.allCases, id: \.self) { chip in
                let isSelected = selectedChip == chip
                Button {
                    selectedChip = chip
                } label: {
                    Text(chip.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(isSelected ? Color.primary2.opacity(0.16) : Color.surface)
                        )
                        .overlay(
                            Capsule().stroke(isSelected ? Color.primary2 : Color.onSurface.opacity(0.2), lineWidth: 1)
                        )
                        .foregroundColor(isSelected ? Color.primary2 : Color.onSurface)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var readingsSection: some View {
        if viewModel.resolvedHistory.isEmpty {
            EmptyState(
                title: "Hamna Usomaji",
                message: "Maneno, nahau, misemo na methali unazoangalia zitaonekana hapa",
                systemImage: "clock.arrow.circlepath"
            )
            .padding(.top, 40)
        } else {
            let rows = HistoryGrouper.group(viewModel.resolvedHistory) { row in
                Double(row.history.createdAt ?? "")
            }

            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                switch row {
                case .header(let bucket):
                    BucketHeader(label: bucket.rawValue)

                case .item(let resolved, _):
                    if let content = resolved.content {
                        readingRow(for: content)
                    }
                    // content == nil means the underlying item was deleted since — skip.
                }
            }
        }
    }

    @ViewBuilder
    private func readingRow(for content: ContentItem) -> some View {
        switch content {
        case .word(let word):
            NavigationLink {
                WordView(deepLinked: false, word: word)
            } label: {
                WordItem(word: word)
            }

        case .idiom(let idiom):
            NavigationLink {
                IdiomView(idiom: idiom)
            } label: {
                IdiomItem(idiom: idiom)
            }

        case .proverb(let proverb):
            NavigationLink {
                ProverbView(proverb: proverb)
            } label: {
                ProverbItem(proverb: proverb)
            }

        case .saying(let saying):
            NavigationLink {
                SayingView(saying: saying)
            } label: {
                SayingItem(saying: saying)
            }
        }
    }

    @ViewBuilder
    private var searchesSection: some View {
        if viewModel.searchHistory.isEmpty {
            EmptyState(
                title: "Hamna Utafutaji",
                message: "Chochote unachotafuta kitaonekana hapa",
                systemImage: "text.magnifyingglass"
            )
            .padding(.top, 40)
        } else {
            let rows = HistoryGrouper.group(viewModel.searchHistory) { search in
                Double(search.createdAt ?? "")
            }

            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                switch row {
                case .header(let bucket):
                    BucketHeader(label: bucket.rawValue)

                case .item(let search, let timestamp):
                    Button {
                        onSearchSelected(search.title ?? "")
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.onSurface.opacity(0.6))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(search.title ?? "")
                                    .font(.system(size: 16))
                                    .foregroundColor(.onSurface)
                                Text(timestamp)
                                    .font(.system(size: 12))
                                    .foregroundColor(.onSurface.opacity(0.5))
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct BucketHeader: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.onSurface.opacity(0.6))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 4)
            .background(.regularMaterial)
    }
}
