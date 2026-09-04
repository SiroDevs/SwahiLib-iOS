//
//  NavigationCoordinator.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var presentedWord: Word?
    @Published var isPresentingWord = false
    
    func navigateToWord(_ word: Word) {
        presentedWord = word
        isPresentingWord = true
    }
    
    func dismissWord() {
        isPresentingWord = false
        presentedWord = nil
    }
}
