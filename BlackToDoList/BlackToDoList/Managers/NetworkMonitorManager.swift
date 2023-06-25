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
    private(set) var isConnected = false {
        didSet {
            print("current status of the user internet connection is \(isConnected)")
        }
    }
    
    private(set) var isExpensive = false
    
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
}
