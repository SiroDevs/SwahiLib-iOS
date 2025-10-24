//
//  NetworkUtils.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import Foundation
import Network

final class NetworkUtils: ObservableObject {
    static let shared = NetworkUtils()
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = false
    @Published var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    private func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = self.getConnectionType(path)
            }
        }
        networkMonitor.start(queue: queue)
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .unknown
        }
    }
    
    func isNetworkAvailable() -> Bool {
        return networkMonitor.currentPath.status == .satisfied
    }
    
    func checkNetworkAvailability() async -> Bool {
        return await withCheckedContinuation { continuation in
            let currentPath = networkMonitor.currentPath
            continuation.resume(returning: currentPath.status == .satisfied)
        }
    }
    
    func getCurrentConnectionType() -> ConnectionType {
        return getConnectionType(networkMonitor.currentPath)
    }
}
