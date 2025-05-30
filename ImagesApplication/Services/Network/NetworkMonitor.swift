//
//  NetworkMonitor.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = false
    var onConnectionRestored: (() -> Void)?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let wasConnected = self?.isConnected ?? false
            self?.isConnected = path.status == .satisfied

            if path.status == .satisfied && !wasConnected {
                DispatchQueue.main.async {
                    self?.onConnectionRestored?()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
