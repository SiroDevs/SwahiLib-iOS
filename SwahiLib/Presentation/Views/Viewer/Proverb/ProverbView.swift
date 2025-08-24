//
//  ProverbView.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.

import SwiftUI

struct ProverbView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ProverbViewModel = {
        DiContainer.shared.resolve(ProverbViewModel.self)
    }()
    
    let proverb: Proverb
    
    @State private var showToast = false
    @State private var showAlert = false
    @State private var showPaywall = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = L10n.favoriteProverb(for: proverb.title, isLiked: viewModel.isLiked)
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .alert(
            L10n.featureLocked,
            isPresented: $showAlert,
            actions: {
                Button(L10n.later, role: .cancel) {}
                Button(L10n.okay) { showPaywall = true }
            },
            message: {
                Text(
                    L10n.featureLockedDescXtra(
                        feature: L10n.featureViewProverbSynonym
                    )
                )
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
        )
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
                PaywallView(displayCloseButton: true)
            #endif
        }
        .task({viewModel.loadProverb(proverb)})
        .onChange(of: viewModel.uiState) { newState in
            if case .liked = newState {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .scaleEffect(5)
                    .tint(.primary1)
            
            case .loaded:
                mainContent
            
            case .liked:
                mainContent
            
            case .error(let msg):
                ErrorState(message: msg) {
                    viewModel.loadProverb(proverb)
                }
                
            default:
                EmptyView()
        }
    }
    
    private var mainContent: some View {
        ProverbDetails(
            viewModel: viewModel,
            title: viewModel.title,
            meanings: viewModel.meanings,
            synonyms: viewModel.synonyms,
            conjugation: viewModel.conjugation,
            onFeatureLocked: { showAlert = true }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeProverb(proverb: proverb)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }

                ShareLink(
                    item: viewModel.shareText(proverb: proverb),
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary1)
                }
            }
        }
        .navigationTitle(L10n.proverbKiswa)
        .navigationBarBackButtonHidden(true)
    }
}
