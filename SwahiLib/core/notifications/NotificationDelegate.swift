//
//  NotificationDelegate.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    private let notifyService: NotificationServiceProtocol
    private let navCoordinator: NavigationCoordinator
    
    override private init() {
        self.notifyService = DiContainer.shared.resolve(NotificationServiceProtocol.self)
        self.navCoordinator = DiContainer.shared.resolve(NavigationCoordinator.self)
        super.init()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let word = notifyService.handleNotificationTap(userInfo) {
            DispatchQueue.main.async {
                self.navCoordinator.navigateToWord(word)
            }
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
