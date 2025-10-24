//
//  InitView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI

struct InitView: View {
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
    }()

    @State private var navigateToNextScreen = false

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
            viewModel.initializeData()
        }
        .onChange(of: viewModel.uiState) { state in
            handleStateChange(state)
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading(let msg):
            LoadingState(
                title: msg ?? "Inapakia data ...",
                fileName: "bar-loader"
            )

        case .saving(let msg):
            VStack {
                LoadingState(
                    title: msg ?? "Inahifadhi data ...",
                    fileName: "opener-loading",
                    showProgress: true,
                    progressValue: viewModel.progress
                )
            }

        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.initializeData()
            }

        case .saved:
            EmptyState()

        default:
            EmptyState()
        }
    }

    private func handleStateChange(_ state: UiState) {
        if case .saved = state {
            navigateToNextScreen = true
        }
    }
}
//
//#Preview {
//    InitView()
//}
