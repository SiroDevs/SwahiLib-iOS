//
//  WordsTaskManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/12/2025.
//

import Foundation
import BackgroundTasks
import Combine

final class WordsTaskManager: ObservableObject {
    static let shared = WordsTaskManager()
    
    @Published var isSavingInBackground = false
    @Published var backgroundTaskError: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let taskIdentifier = "com.swahilib.BgWordsTask.Processing"
    
    private init() {
        setupBackgroundTask()
    }
    
    func setupBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: taskIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }
    
    func scheduleBackgroundSave(immediately: Bool = false) {
        let request = BGProcessingTaskRequest(identifier: taskIdentifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        request.earliestBeginDate = immediately ? Date() : Date(timeIntervalSinceNow: 1)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background task scheduled")
        } catch {
            print("❌ Failed to schedule background task: \(error)")
        }
    }
    
    private func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundSave(immediately: false)
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            Task { @MainActor in
                self.isSavingInBackground = false
            }
        }
        
        Task {
            await saveDataInBackground(task: task)
        }
    }
    
    private func saveDataInBackground(task: BGProcessingTask) async {
        await MainActor.run {
            self.isSavingInBackground = true
            self.backgroundTaskError = nil
        }
        
        do {
            let wordRepo = DiContainer.shared.resolve(WordRepoProtocol.self)
            
            let fetchedWords = try await wordRepo.fetchRemoteData()
            try await saveBatch(words: fetchedWords, wordRepo: wordRepo)
            
            await MainActor.run {
                self.isSavingInBackground = false
            }
            
            task.setTaskCompleted(success: true)
            print("✅ Background data saving completed successfully")
            
        } catch {
            await MainActor.run {
                self.isSavingInBackground = false
                self.backgroundTaskError = error.localizedDescription
            }
            task.setTaskCompleted(success: false)
            print("❌ Background data saving failed: \(error)")
        }
    }
    
    private func saveBatch(
        words: [Word],
        wordRepo: WordRepoProtocol,
    ) async throws {
        print("Now saving words")
        for (index, word) in words.enumerated() {
            wordRepo.saveWord(word)
        }
        print("✅ Words saved successfully")
    }
    
    func cancelBackgroundTask() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskIdentifier)
        isSavingInBackground = false
    }
}
