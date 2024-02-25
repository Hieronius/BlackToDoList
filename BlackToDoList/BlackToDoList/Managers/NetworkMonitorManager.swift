import UIKit
import Network

final class NetworkMonitorManager {
    
    // MARK: - Static Properties
    
    static let shared = NetworkMonitorManager()
    
    // MARK: - Private Properties
    
    private let monitor: NWPathMonitor
    
    /// Custom spinner which presents when user lost internet connection.
    private let spinningCircle = SpinningCircleView()
    
    private var spinnerBackgroundView = UIView()
    
    /// Getter of this variable is internal but Setter is private
    private(set) var isConnected = false {
        didSet {
            throwNoInternetConnectionSpinner()
        }
    }
    
    /// Property to evaluate current user internet connection. Expensive can be cellular and wi-fi from hotSpot internet connection.
    private(set) var isExpensive = false
    
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    
    // MARK: - Initializers
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // MARK: - Public Methods
    
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
    
    // MARK: - Private Methods
    
    private func throwNoInternetConnectionSpinner() {
        DispatchQueue.main.async {
            let currentViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            if self.isConnected {
                if currentViewController?.presentedViewController as? UIAlertController != nil {
                    currentViewController?.presentedViewController?.dismiss(animated: true)
                } else {
                    self.spinnerBackgroundView.removeFromSuperview()
                    self.spinningCircle.removeFromSuperview()
                }
                
            } else {
                if currentViewController?.presentedViewController as? UIAlertController != nil {
                    currentViewController?.presentedViewController?.dismiss(animated: true)
                } else {
                    self.configureSpinnerBackgroundAndDisplay(currentViewController ?? UIViewController())
                    self.configureSpinnerAndDisplay(currentViewController ?? UIViewController())
                    currentViewController?.showAlert(title: "Internet connection status",
                                                     message: "Check your internet connection")
                }
            }
        }
    }
}

// MARK: - Extension of custom spinner "no internet connection" UI

extension NetworkMonitorManager {
    
    private func configureSpinnerBackgroundAndDisplay(_ currentViewController: UIViewController) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        spinnerBackgroundView = UIVisualEffectView(effect: blurEffect)
        spinnerBackgroundView.frame = currentViewController.view.bounds
        spinnerBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spinnerBackgroundView.alpha = 0.8
        currentViewController.view.addSubview(spinnerBackgroundView)
    }
    
    private func configureSpinnerAndDisplay(_ currentViewController: UIViewController) {
        spinningCircle.translatesAutoresizingMaskIntoConstraints = false
        spinningCircle.frame = CGRect(x: currentViewController.view.center.x - 50,
                                      y: currentViewController.view.center.y - 50,
                                      width: 100,
                                      height: 100)
        currentViewController.view.addSubview(spinningCircle)
    }
}

