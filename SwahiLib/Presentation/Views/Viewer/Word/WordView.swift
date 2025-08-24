//
//  WordView.swift
//  SwahiLib
//
//  Created by Siro Daves on 01/08/2025.


import SwiftUI

struct WordView: View {
    @StateObject private var viewModel: WordViewModel = {
        DiContainer.shared.resolve(WordViewModel.self)
    }()
    
    let word: Word
    
    @State private var showToast = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = viewModel.isLiked
                    ? "Neno \(word.title) limeongezwa kwa vipendwa"
                    : "Neno \(word.title) limeondolewa kutoka kwa vipendwa"
                
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
       }
        .task({viewModel.loadWord(word)})
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
                    viewModel.loadWord(word)
                }
                
            default:
                EmptyView()
        }
    }
    
    private var mainContent: some View {
        WordDetails(
            viewModel: viewModel,
            title: viewModel.title,
            meanings: viewModel.meanings,
            synonyms: viewModel.synonyms,
            conjugation: viewModel.conjugation,
        )
        .navigationTitle("Neno la Kiswahili", )
    }
}

#Preview{
    WordView(
        word: Word.sampleWords[0]
    )
}
