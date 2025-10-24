//
//  ContentView.swift
//  SwahiLib
//
//  Created by @sirodevs on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    private let prefsRepo: PreferencesRepository
    
    @State private var navigateToNextScreen = false
    
    init(prefsRepo: PreferencesRepository) {
        self.prefsRepo = prefsRepo
    }
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                if prefsRepo.isDataLoaded {
                    HomeView()
                } else {
                    InitView()
                }
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            navigateToNextScreen = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
}
