import UIKit
import LocalAuthentication

final class BiometricManager {
    
    static var isUserGavePermissionToUseBiometrics = false
    
    static func askForBiometricsAndRedirectToMainScreen(_ viewController: UIViewController) {
        let context = LAContext()
        let reason = "Please identify yourself"
        
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { [weak viewController] success, error in
            
            guard success, error == nil else {
                
                DispatchQueue.main.async {
                    viewController?.showAlert(title: "Failed to Authenticate", message: "Authentication has been canceled", okButtonName: "Continue") {
                        viewController?.segueToMainScreenAndMakeItRootVC(viewController!)
                    }
                }
                return
            }
            viewController?.segueToMainScreenAndMakeItRootVC(viewController!)
        }
    }
}
