//
//  AppModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 16/12/2025.
//

import BackgroundTasks

@MainActor
class AppModel {
    func scheduleRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: AppConstants.wordsRefreshTask)
        request.earliestBeginDate = Date().addingTimeInterval(60 * 5)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Task scheduled")
        } catch {
            print("Task schedule error: \(error)")
        }
    }
}
