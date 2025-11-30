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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var navCoordinator: NavigationCoordinator
    private let notifyService: NotificationServiceProtocol
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
        
        let navCoordinator = DiContainer.shared.resolve(NavigationCoordinator.self)
        _navCoordinator = StateObject(wrappedValue: navCoordinator)
        
        notifyService = DiContainer.shared.resolve(NotificationServiceProtocol.self)
        
        setupNotifications()
        
        #if !DEBUG
            Purchases.configure(withAPIKey: AppSecrets.rc_api_key)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let word = navCoordinator.presentedWord {
                    SplashView(deepLinked: true, word: word)
                } else {
                    SplashView(deepLinked: false, word: Word.sampleWords[0])
                }
            }
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
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        notifyService.checkNotificationPermission()
    }
    
    private func handleDeepLink(_ url: URL) {
        print("Deep link received: \(url)")
    }

}
