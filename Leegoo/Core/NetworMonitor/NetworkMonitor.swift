//
//  NetworkMonitor.swift
//  Leegoo
//
//  Created by TaqieAllah on 07/05/2026.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected = true

    private init() {}

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            self?.isConnected = connected

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .networkStatusDidChange,
                    object: connected
                )
            }
        }

        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let networkStatusDidChange = Notification.Name("networkStatusDidChange")
}
