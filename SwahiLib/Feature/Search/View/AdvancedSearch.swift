//
//  AdvancedSearch.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import SwiftUI

struct AdvancedSearch: View {
    @StateObject private var viewModel: SearchViewModel = {
        DiContainer.shared.resolve(SearchViewModel.self)
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
                title: "Inapakia data ..."
            )
            
        case .filtered:
            AdvancedSearchView(viewModel: viewModel)
            
        case .error(let msg):
            ErrorState(message: msg) {
                Task { viewModel.fetchData() }
            }
            
        default:
            LoadingState(
                title: "Inapakia data ..."
            )
        }
    }
}
