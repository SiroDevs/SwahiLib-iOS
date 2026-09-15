//
//  DailyWordScreen.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct DailyWordScreen: View {
    @StateObject private var viewModel: DailyContentViewModel = {
        DiContainer.shared.resolve(DailyContentViewModel.self)
    }()

    var body: some View {
        DailyContentScaffold(
            viewModel: viewModel,
            title: "Neno la Siku",
            uiState: viewModel.uiState,
            itemPresent: viewModel.dailyWord != nil,
            emptyMessage: "Hamna neno la siku kwa sasa. Jaribu tena baadaye.",
            heroTitle: viewModel.dailyWord?.title ?? "",
            heroSubtitle: viewModel.dailyWord?.english,
            meaning: viewModel.dailyWordMeaning
        ) {
            if let word = viewModel.dailyWord {
                WordView(deepLinked: false, word: word)
            }
        }
        .onAppear {
            if viewModel.dailyWord == nil {
                viewModel.loadDailyContent()
            }
        }
    }
}
