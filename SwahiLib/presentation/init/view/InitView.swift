//
//  InitView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI
import BackgroundTasks

struct InitView: View {
    @StateObject private var wordsBgTask = WordsTaskManager.shared
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
    }()

    @State private var navigateToNextScreen = false
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                MainView()
            } else {
                mainContent
            }
        }
        .onAppear {
            startInitialization()
//            wordsBgTask.scheduleBackgroundSave()
        }
    }

    private var mainContent: some View {
        VStack {
            stateContent
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

        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.initializeData()
            }

        case .saved:
            EmptyState()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        wordsBgTask.scheduleBackgroundSave(immediately: true)
                    }
                    navigateToNextScreen = true
                }

        default:
            EmptyState()
        }
    }

    private func startInitialization() {
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        
        if prefsRepo.isDataLoaded {
            navigateToNextScreen = true
        } else {
            viewModel.initializeData()
        }
    }
}
