//
//  DailyContentHistoryScreen.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct DailyContentHistoryScreen: View {
    @ObservedObject var viewModel: DailyContentViewModel
    @State private var showClearConfirm = false

    var body: some View {
        Group {
            if viewModel.history.isEmpty {
                EmptyState(
                    title: "Hamna Historia",
                    message: "Neno na methali za siku zilizopita zitaonekana hapa",
                    systemImage: "calendar"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.history) { entry in
                            DailyContentHistoryRow(entry: entry)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle("Historia ya Siku")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .toolbar {
            if !viewModel.history.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showClearConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert("Futa Historia ya Siku?", isPresented: $showClearConfirm) {
            Button("Futa", role: .destructive) { viewModel.clearHistory() }
            Button("Ghairi", role: .cancel) {}
        } message: {
            Text("Utaondoa maneno na methali zote za siku zilizopita.")
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
}

private struct DailyContentHistoryRow: View {
    let entry: DailyContentHistoryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.content.date)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.onSurface.opacity(0.5))

            if let word = entry.word {
                NavigationLink {
                    WordView(deepLinked: false, word: word)
                } label: {
                    HStack {
                        Image(systemName: "text.book.closed")
                            .foregroundColor(.primary1)
                        Text(word.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.onSurface)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.onSurface.opacity(0.3))
                    }
                }
                .buttonStyle(.plain)
            }

            if let proverb = entry.proverb {
                NavigationLink {
                    ProverbView(proverb: proverb)
                } label: {
                    HStack {
                        Image(systemName: "quote.opening")
                            .foregroundColor(.primary2)
                        Text(proverb.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.onSurface)
                            .lineLimit(2)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.onSurface.opacity(0.3))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.surface))
    }
}
