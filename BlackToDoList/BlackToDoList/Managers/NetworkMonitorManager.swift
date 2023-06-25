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
    
    /// Getter of this variable is internal but Setter is private
    private(set) var isConnected = false
    
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    
    
    private init() {
        monitor = NWPathMonitor()
    }
}
