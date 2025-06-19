//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step2View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    
    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            navigateToNextScreen ? AnyView(HomeView()) : AnyView(mainContent)
        }
    }
    
    private var mainContent: some View {
        VStack {
            stateContent
        }
        .task({viewModel.fetchSongs()})
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingView(title: msg ?? "Loading ...")
                
            case .saving(let msg):
                LoadingView(title: msg ?? "Saving ...")
                
            case .saved:
                LoadingView()
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchSongs() }
                }
                
            default:
                LoadingView()
        }
    }
    
    private func handleStateChange(_ state: ViewUiState) {
        if case .saved = state {
            navigateToNextScreen = true
        } else if case .fetched = state {
            viewModel.saveSongs()
        }
    }
}

#Preview {
    Step2View()
}
