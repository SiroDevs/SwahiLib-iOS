//
//  IdiomView.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/08/2025.

import SwiftUI

struct IdiomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: IdiomViewModel = {
        DiContainer.shared.resolve(IdiomViewModel.self)
    }()
    
    let idiom: Idiom
    
    @State private var showToast = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = L10n.likedIdiom(for: idiom.title, isLiked: viewModel.isLiked)
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarTitleDisplayMode(.inline)
        .task({viewModel.loadIdiom(idiom)})
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
                    viewModel.loadIdiom(idiom)
                }
                
            default:
                EmptyView()
        }
    }
    
    private var mainContent: some View {
        IdiomDetails(
            title: viewModel.title,
            meanings: viewModel.meanings,
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeIdiom(idiom: idiom)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }

                ShareLink(
                    item: viewModel.shareText(idiom: idiom),
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary1)
                }
            }
        }
        .navigationTitle(L10n.idiomKiswa)
        .navigationBarBackButtonHidden(true)
    }
}

struct IdiomDetails: View {
    var title: String
    var meanings: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CollapsingHeader(title: title)

                if !meanings.isEmpty {
                    MeaningsView(meanings: meanings)
                }
            }
        }
    }
}
