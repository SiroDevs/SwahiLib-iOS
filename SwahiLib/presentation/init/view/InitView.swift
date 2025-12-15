//
//  InitView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI
import BackgroundTasks

struct InitView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
    }()
    
    @State private var navigateToNextScreen = false
    let wordsRefreshTask = "com.swahilib.wordstask.refresh"
    let wordsProcessingTask = "com.swahilib.wordstask.processing"
    
    func registerBGTaskScheduler() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: wordsRefreshTask, using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: wordsProcessingTask, using: nil) { task in
             self.handleProcessingTask(task: task as! BGProcessingTask)
        }

    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: wordsRefreshTask)
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
          try BGTaskScheduler.shared.submit(request)
        } catch {
          print("Could not schedule app refresh: \(error)")
        }
    }
    
    func scheduleProcessing() {
        let request = BGProcessingTaskRequest(identifier: wordsProcessingTask)
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule processing: \(error)")
       }
    }
    
    func handleProcessingTask(task: BGProcessingTask) {
        let operation = SampleOperation(text: "Hello world! v2")
        
        task.expirationHandler = {
           operation.cancel()
        }

        operation.completionBlock = {
           task.setTaskCompleted(success: !operation.isCancelled)
        }

         let queue = OperationQueue()

         queue.addOperation(operation)
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
       scheduleAppRefresh()

       let operation = SampleOperation(text: "Hello world!")
       
       task.expirationHandler = {
          operation.cancel()
       }

       operation.completionBlock = {
          task.setTaskCompleted(success: !operation.isCancelled)
       }

        let queue = OperationQueue()

        queue.addOperation(operation)
     }
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                MainView()
            } else {
                mainContent
            }
        }
        .onAppear {
            startInitialization()
            registerBGTaskScheduler()
//            scheduleAppRefresh()
//            scheduleProcessing()
        }
    }

    private var mainContent: some View {
        VStack {
            stateContent
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading(let msg):
            LoadingState(
                title: msg ?? "Inapakia data ...",
                fileName: "bar-loader"
            )

        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.initializeData()
            }

        case .saved:
            EmptyState()
                .onAppear {
                    navigateToNextScreen = true
                }

        default:
            EmptyState()
        }
    }

    private func startInitialization() {
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        
        if prefsRepo.isDataLoaded {
            navigateToNextScreen = true
        } else {
            viewModel.initializeData()
        }
    }
}

final class SampleOperation: Operation {

    let text: String

    init(text: String) {
        self.text = text
        super.init()
    }

    override func main() {
        guard !isCancelled else { return }
        print("Text:", text)
    }
}
