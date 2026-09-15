//
//  DailyProverbScreen.swift
//  SwahiLib
//
//  Mirrors Android's Daily Proverb screen (feature/daily_content), built
//  on the shared DailyContentScaffold.
//

import SwiftUI

struct DailyProverbScreen: View {
    @StateObject private var viewModel: DailyContentViewModel = {
        DiContainer.shared.resolve(DailyContentViewModel.self)
    }()

    var body: some View {
        DailyContentScaffold(
            viewModel: viewModel,
            title: "Methali ya Siku",
            uiState: viewModel.uiState,
            itemPresent: viewModel.dailyProverb != nil,
            emptyMessage: "Hamna methali ya siku kwa sasa. Jaribu tena baadaye.",
            heroTitle: viewModel.dailyProverb?.title ?? "",
            heroSubtitle: nil,
            meaning: viewModel.dailyProverbMeaning
        ) {
            if let proverb = viewModel.dailyProverb {
                ProverbView(proverb: proverb)
            }
        }
        .onAppear {
            if viewModel.dailyProverb == nil {
                viewModel.loadDailyContent()
            }
        }
    }
}
