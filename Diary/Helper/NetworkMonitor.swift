//
//  NetworkMonitor.swift
//  Diary
//
//  Created by Immanuel on 17/04/24.
//

import Foundation
import Network

enum NetworkStatus: String {
    case online
    case offline
}

@Observable
class NetworkMonitor {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
    var status: NetworkStatus = .offline
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.status = .online
            } else {
                self?.status = .offline
            }
        }
        monitor.start(queue: queue)
    }
    
    
}
