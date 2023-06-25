//
//  Biometric.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 24.06.2023.
//

import UIKit
import LocalAuthentication

final class BiometricManager {
    
    static var isUserGavePermissionToUseBiometrics = false {
        didSet {
            print("Current status of Biometric Manager access - \(isUserGavePermissionToUseBiometrics)")
        }
    }
    
    static func askForBiometrics(_ viewController: UIViewController) {
        
        // Create an abstractive model of the Apple Authentication Manager.
        let context = LAContext()
        
        
        
        
        // Create an abstractive model for possible Errors during the usage of the service.
        // Because this framework works with protocol NSErrorPointer and also it's a inout parameter.
        var error: NSError? = nil
            
            // Seems like it's a message which should ask User to use his TouchID.
            // Probably should be edited accordingly to variation that it can be FaceID check.
            let reason = "Please identify yourself"
            
            // MARK: ACTUAL FACEID/TOUCHID/DEFAULT IPHONE PIN CODE CHECKOUT WITH A SEGUE TO THE MAIN SCREEN IN CASE OF SUCCESS
            // context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
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
                
                // self.isUserGavePermissionToUseBiometrics = true
                print("User gave permission to use biometrics - \(BiometricManager.isUserGavePermissionToUseBiometrics)")
                viewController?.segueToMainScreenAndMakeItAsRootTest(viewController!)
                
            }
        }
}
