//
//  Biometric.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 24.06.2023.
//

import UIKit
import LocalAuthentication

final class BiometricManager {
    
    static var isUserGavePermissionToUseBiometrics = false
    
    static func askForBiometrics(_ viewController: UIViewController) {
        let context = LAContext()
        let reason = "Please identify yourself"
        
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { [weak viewController] success, error in
            
            guard success, error == nil else {
                
                DispatchQueue.main.async {
                    // Failure of the attempt to check
                    print("Authentication has been failed")
                    viewController?.showAlert(title: "Failed to Authenticate", message: "Authentication has been canceled", okButtonName: "Continue") {
                        viewController?.segueToMainScreenAndMakeItAsRootTest(viewController!)
                    }
                }
                return
            }
            viewController?.segueToMainScreenAndMakeItAsRootTest(viewController!)
        }
    }
}
