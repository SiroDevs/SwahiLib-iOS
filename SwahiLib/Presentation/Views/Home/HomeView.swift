//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "opener-loading",
                )
            case .filtered:
                HomeContent(
                    viewModel: viewModel,
                )
               
            case .error(let msg):
                ErrorState(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "circle-loader",
                )
        }
    }
}
