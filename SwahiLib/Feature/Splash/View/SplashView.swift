//
//  SplashView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel = {
        DiContainer.shared.resolve(SplashViewModel.self)
    }()
    @State private var navigateToNextScreen = false
    @State private var didStartInit = false
    
    let deepLinked: Bool
    let word: Word
    
    var body: some View {
        Group {
            // The parental gate is always the very first screen for a user who
            // hasn't passed it yet, regardless of launch path (normal, deep link,
            // notification) and without waiting for init or the data sync.
            if viewModel.needsParentalGate {
                ParentalGateView {
                    viewModel.completeParentalGate()
                }
            } else if navigateToNextScreen {
                destinationView
            } else {
                SplashContent()
            }
        }
        .onAppear {
            guard !didStartInit else { return }
            didStartInit = true
            viewModel.initialize()
        }
        .onReceive(viewModel.$isInitialized) { initialized in
            if initialized {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToNextScreen = true
                }
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
    
    /// First-time, non-PRO users get the paywall right after the gate.
    private var showLaunchPaywall: Bool {
        viewModel.passedGateThisSession && !viewModel.isProUser
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if viewModel.prefsRepo.isDataLoaded {
            if deepLinked {
                WordView(deepLinked: true, word: word)
            } else {
                HomeView(showPaywallOnLaunch: showLaunchPaywall)
            }
        } else {
            InitView(showPaywallOnLaunch: showLaunchPaywall)
        }
    }
}

struct SplashContent: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(.mainIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text(AppConstants.appTitle)
                .font(.system(size: 50, weight: .bold))
                .kerning(5)
                .foregroundColor(.primary1)
                .padding(.top, 5)
            
            Text(AppConstants.appTitle2)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.primary1)
            
            Spacer()
            
            Text(AppConstants.appTagline)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary1)
            .padding(.bottom, 20)
            
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 100)
                .background(.onPrimaryContainer)

            Text(AppConstants.appCredits)
                .font(.system(size: 16))
                .foregroundColor(.primary1)
            .padding(.top, 20)

            Spacer().frame(height: 20)
        }.padding()
    }
}

#Preview {
    SplashView(deepLinked: false, word: Word.sampleWords[0])
}
