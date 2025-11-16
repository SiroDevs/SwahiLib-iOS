//
//  NotificationManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
}

extension NotificationManager {
    func scheduleDailyWordNotification(at hour: Int = 6, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        
        // Remove any existing notifications
        center.removePendingNotificationRequests(withIdentifiers: ["wordOfTheDay"])
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Neno la Siku"
        content.body = getTodaysWord()
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "wordOfTheDay",
            content: content,
            trigger: trigger
        )
        
        // Add the notification request
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily word notification scheduled for \(hour):\(minute)")
            }
        }
    }
    
    private func getTodaysWord() -> String {
        // This is where you'll fetch from your database
        // For now, return a placeholder
        return "Check out today's featured word!"
    }
}
