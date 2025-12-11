//
//  AppDelegate.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/11/2025.
//

import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    private var backgroundProcessing: BGProcessingTask?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        if prefsRepo.notificationsEnabled {
            let notifyService = DiContainer.shared.resolve(NotificationServiceProtocol.self)
            notifyService.checkNotificationPermission()
            
            let hour = prefsRepo.notificationHour
            let minute = prefsRepo.notificationMinute
            notifyService.scheduleDailyWordNotification(at: hour, minute: minute)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppConstants.wordsRefreshTask, using: nil) { task in
            self.handleBackgroundRefresh(task: task as! BGProcessingTask)
        }
        scheduleWordsBackgroundTask()
        return true
    }
    
    private func handleBackgroundRefresh(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        Task {
            await startWordProcessing(task: task)
        }
    }
    
    private func scheduleWordsBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: AppConstants.wordsRefreshTask)
        
        request.earliestBeginDate = Date()
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("❌ Failed to schedule background task: \(error)")
        }
    }
    
    @MainActor
    private func startWordProcessing(task: BGProcessingTask) async {
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        
        guard !prefsRepo.isDataLoaded else {
            task.setTaskCompleted(success: true)
            return
        }
        
        do {
            let wordRepo = DiContainer.shared.resolve(WordRepoProtocol.self)
            let fetchedWords = try await wordRepo.fetchRemoteData()
            
            print("⏳ Saving \(fetchedWords.count) words...")
            for word in fetchedWords {
                wordRepo.saveWord(word)
            }
            
            print("✅ Background data saving completed successfully")
            task.setTaskCompleted(success: true)
        } catch {
            print("❌ Background data saving failed: \(error)")
            task.setTaskCompleted(success: false)
        }
    }
}
