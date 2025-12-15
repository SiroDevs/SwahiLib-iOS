//
//  Untitled.swift
//  SwahiLib
//
//  Created by @sirodevs on 16/12/2025.
//


import UIKit
import BackgroundTasks

class AppDelegateX: NSObject, UIApplicationDelegate {
    private var backgroundProcessing: BGProcessingTask?
    let wordsRefreshTask = "com.swahilib.wordstask.refresh"
    let wordsProcessingTask = "com.swahilib.wordstask.processing"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        if prefsRepo.notificationsEnabled {
            let notifyService = DiContainer.shared.resolve(NotificationServiceProtocol.self)
            notifyService.checkNotificationPermission()
            
            let hour = prefsRepo.notificationHour
            let minute = prefsRepo.notificationMinute
            notifyService.scheduleDailyWordNotification(at: hour, minute: minute)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: wordsRefreshTask, using: nil) { task in
            self.handleBgWordsRefresh(task: task as! BGAppRefreshTask)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: wordsProcessingTask, using: nil) { task in
            self.handleBgWordsProcessing(task: task as! BGProcessingTask)
        }
        scheduleWordsBackgroundTask()
        return true
    }
    
    private func handleBgWordsRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
    }
    
    private func handleBgWordsProcessing(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        Task {
            await startWordProcessing(task: task)
        }
    }
    
    private func scheduleWordsBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: wordsProcessingTask)
        
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
