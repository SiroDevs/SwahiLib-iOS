//
//  DailyContentScaffold.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct DailyContentScaffold<FullDetail: View>: View {
    @ObservedObject var viewModel: DailyContentViewModel
    let title: String
    let uiState: UiState
    let itemPresent: Bool
    let emptyMessage: String
    let heroTitle: String
    let heroSubtitle: String?
    let meaning: String
    @ViewBuilder let fullDetail: () -> FullDetail

    @Environment(\.dismiss) private var dismiss
    @State private var showFullDetail = false

    var body: some View {
        Group {
            switch uiState {
            case .loading:
                LoadingState(title: "Inapakia ...")

            default:
                if !itemPresent {
                    Text(emptyMessage)
                        .font(.body)
                        .foregroundColor(.onSurface.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(32)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            CollapsingHeader(title: heroTitle, subtitle: heroSubtitle)
                                .padding(.top, 16)

                            if !meaning.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("MAANA")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.primary1)
                                        .tracking(1.5)
                                    Text(meaning)
                                        .font(.system(size: 16))
                                        .foregroundColor(.onSurface)
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12).fill(Color.surface)
                                )
                                .padding(.horizontal, 16)
                            }

                            Button {
                                showFullDetail = true
                            } label: {
                                Text("Tazama Maelezo Zaidi")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary2))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    DailyContentHistoryScreen(viewModel: viewModel)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $showFullDetail) {
            NavigationStack {
                fullDetail()
            }
        }
    }
}
