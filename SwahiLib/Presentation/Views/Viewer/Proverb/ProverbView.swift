//
//  ProverbView.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.


import SwiftUI

struct ProverbView: View {
    @StateObject private var viewModel: ProverbViewModel = {
        DiContainer.shared.resolve(ProverbViewModel.self)
    }()
    
    let proverb: Proverb
    
    @State private var showToast = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = viewModel.isLiked
                    ? "\(proverb.title) added to your likes"
                    : "\(proverb.title) removed from your likes"
                
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
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
        )
        .navigationTitle("Methali ya Kiswahili", )
    }
}
