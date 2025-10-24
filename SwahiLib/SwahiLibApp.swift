//
//  SwahiLibApp.swift
//  SwahiLib
//
//  Created by @sirodevs on 29/04/2025.
//

import SwiftUI
import RevenueCat

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
        
        #if !DEBUG
            Purchases.configure(withAPIKey: AppSecrets.rc_api_key)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(prefsRepo: PrefsRepo())
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
