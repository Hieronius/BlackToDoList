//
//  NetworkManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 25.06.2023.
//
import UIKit
import Network

final class NetworkMonitorManager {
    static let shared = NetworkMonitorManager()
    
    private let monitor: NWPathMonitor
    
    // MARK: Create documentation for this property
    /// Getter of this variable is internal but Setter is private
    private(set) var isConnected: Bool? {
        didSet {
            DispatchQueue.main.async {
                print("current status of the user internet connection is \(self.isConnected)")
                let currentViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
                if currentViewController?.presentedViewController as? UIAlertController != nil {
                    currentViewController?.presentedViewController?.dismiss(animated: true)
                    
                } else {
                    currentViewController?.showAlert(title: "Internet connection status", message: "Check your internet connection")
                }
                
                print("current view controller \(currentViewController)")
            }
        }
        }
    
    private(set) var isExpensive = false
    
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    
    /// This method starts monitoring network connectivity by setting the `pathUpdateHandler` property of the `monitor` object and calling the `start(queue:)` method.
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
