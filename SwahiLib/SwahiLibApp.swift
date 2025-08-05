//
//  SwahiLibApp.swift
//  SwahiLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

@main
struct SwahiLibApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.label
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(prefsRepo: PrefsRepository())
            .environmentObject(themeManager)
            .preferredColorScheme({
                switch themeManager.selectedTheme {
                case .system: return nil
                case .light: return .light
                case .dark: return .dark
                }
            }())
        }
    }
}
