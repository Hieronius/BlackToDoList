//
//  NetworkManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 25.06.2023.
//

import Network

final class NetworkMonitorManager {
    static let shared = NetworkMonitorManager()
    
    private let monitor: NWPathMonitor
    
    private init() {
        monitor = NWPathMonitor()
    }
}
