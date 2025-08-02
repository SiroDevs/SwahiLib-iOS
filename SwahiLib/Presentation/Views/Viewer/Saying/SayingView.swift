//
//  SayingView.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.


import SwiftUI

struct SayingView: View {
    @StateObject private var viewModel: SayingViewModel = {
        DiContainer.shared.resolve(SayingViewModel.self)
    }()
    
    let saying: Saying
    
    @State private var showToast = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = viewModel.isLiked
                    ? "\(saying.title) added to your likes"
                    : "\(saying.title) removed from your likes"
                
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
       }
        .task({viewModel.loadSaying(saying)})
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
                    viewModel.loadSaying(saying)
                }
                
            default:
                EmptyView()
        }
    }
    
    private var mainContent: some View {
        SayingDetails(
            title: viewModel.title,
            meanings: viewModel.meanings,
        )
        .navigationTitle("Msemo wa Kiswahili", )
    }
}

struct SayingDetails: View {
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
