//
//  NetworkMonitor.swift
//  MyWeather
//
//  Created by Illia Verezei on 28.12.2024.
//

import Network

final class NetworkMonitor {
  static let shared = NetworkMonitor()
  
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")
  private(set) var isConnected = true
  
  var onStatusChange: ((Bool) -> ())?
  
  private init() {
    monitor.pathUpdateHandler = { [weak self] path in
      let newConnectionState = path.status == .satisfied
      DispatchQueue.main.async {
        self?.isConnected = newConnectionState
        self?.onStatusChange?(newConnectionState)
      }
    }
    monitor.start(queue: queue)
  }
  
  deinit {
    monitor.cancel()
  }
}
