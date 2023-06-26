//
//  NetworkManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 25.06.2023.
//
import UIKit
import Network

final class NetworkMonitorManager {
    
    // MARK: - Private Properties
    
    static let shared = NetworkMonitorManager()
    
    private let monitor: NWPathMonitor
    
    private let spinningCircle = SpinningCircleView()
    
    
    // MARK: Create documentation for this property
    /// Getter of this variable is internal but Setter is private
    private(set) var isConnected = false {
        didSet {
            
            // MARK: PUT THE CODE TO THE PRIVATE LOCAL FUNCTION
            // 0. Define all actions on the main thread:
            DispatchQueue.main.async {
                // 1. Define current presented view controller:
                let currentViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
                // 2. If we have internet connection:
                if self.isConnected {
                    // 3. If we already presented an alert controller:
                    if currentViewController?.presentedViewController as? UIAlertController != nil {
                        // 3.A) Dismiss this alert controller:
                        print("3.A")
                        currentViewController?.presentedViewController?.dismiss(animated: true)
                    } else {
                        print("3.B")
                        // There we don't need to present any controllers, because user has internet connection.
                        // MARK: STILL RUNS THIS CHUNK OF CODE TWICE
                        // probably need a check is there a presented spinner or not.
                        self.spinningCircle.removeFromSuperview()
                        // 3.B) Present an alert controller:
                        // currentViewController?.showAlert(title: "Internet connection status", message: "Check your internet connection")
                    }
                    // 4. If we don't have internet connection:
                } else {
                    // 5. If we already presented an alert controller:
                    if currentViewController?.presentedViewController as? UIAlertController != nil {
                        print("5.A")
                        // 5.A) Dismiss this alert controller:
                        currentViewController?.presentedViewController?.dismiss(animated: true)
                    } else {
                        print("5.B")
                        // There we should present our spinner.
                        currentViewController?.view.addSubview(self.spinningCircle)
                        // 5.B) Present an alert controller:
                        currentViewController?.showAlert(title: "Internet connection status", message: "Check your internet connection")
                    }
                    
                }
            }
        }
    }
    
    private(set) var isExpensive = false
    
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    
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
    
    
//    private func configureSpinningCircleAndDisplay(_ currentViewController: UIViewController) {
//        spinningCircle.frame = CGRect(x: -50, y: 100, width: 100, height: 100)
//        currentViewController.view.addSubview(spinningCircle)
//    }
    
    private func dismissSpinningCircle(_ currentViewController: UIViewController) {
        currentViewController.view.willRemoveSubview(spinningCircle)
    }
}

