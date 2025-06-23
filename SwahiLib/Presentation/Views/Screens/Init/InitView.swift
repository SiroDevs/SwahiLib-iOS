//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct InitView: View {
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
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
        .task({viewModel.fetchData()})
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingView(title: msg ?? "Inapakia Data ...")
                
            case .saving(let msg):
                LoadingView(title: msg ?? "Inahifadhi Data ...")
                
            case .saved:
                LoadingView()
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchData() }
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
    InitView()
}
