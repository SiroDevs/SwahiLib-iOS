//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import SwiftUI

struct InitView: View {
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
    }()
    
    @State private var navigateToNextScreen = false
    @State private var hasFetched = false

    var body: some View {
        Group {
            if navigateToNextScreen {
                HomeView()
            } else {
                mainContent
            }
        }
    }
    
    private var mainContent: some View {
        VStack {
            stateContent
        }
        .onAppear {
            // Ensure fetchData is only called once
            if !hasFetched {
                viewModel.fetchData()
                hasFetched = true
            }
        }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading:
            LoadingState(
                title: "Inapakia data ...",
                fileName: "opener-loading",
            )
            
        case .saving:
            VStack {
                LoadingState(
                    title: viewModel.status,
                    fileName: "opener-loading",
                )
                ProgressView(value: Double(viewModel.progress), total: 100)
                    .padding(.top, 12)
            }
            
        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.fetchData()
            }
            
        case .loaded:
            EmptyView()
            
        default:
            EmptyView()
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        switch state {
        case .loaded:
            viewModel.saveData()
        case .saved:
            navigateToNextScreen = true
        default:
            break
        }
    }
}

#Preview {
    InitView()
}
