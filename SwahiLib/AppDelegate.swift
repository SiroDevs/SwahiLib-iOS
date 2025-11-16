//
//  AppDelegate.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        if prefsRepo.notificationsEnabled {
            let notifySvc = DiContainer.shared.resolve(NotificationServiceProtocol.self)
            notifySvc.checkNotificationPermission()
            
            let hour = prefsRepo.notificationHour
            let minute = prefsRepo.notificationMinute
            notifySvc.scheduleDailyWordNotification(at: hour, minute: minute)
        }
        
        return true
    }
}
