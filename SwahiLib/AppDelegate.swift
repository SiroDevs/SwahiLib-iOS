//
//  AppDelegate.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Request notification permission
        NotificationManager.shared.requestNotificationPermission()
        
        // Schedule notifications (you might want to do this after user sets preferences)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NotificationManager.shared.scheduleDailyWordNotification(at: 6, minute: 0)
        }
        
        return true
    }
}
