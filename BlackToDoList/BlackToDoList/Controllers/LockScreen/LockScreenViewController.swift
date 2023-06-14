//
//  LockScreenViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import LocalAuthentication

final class LockScreenViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some core here
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: ACTION TO ACTIVATE FACEID/TOUCHID OF THE USER
    @IBAction private func authenticationButton(_ sender: Any) {
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
                               localizedReason: reason) { [weak self] success, error in
            
            // Do the job asynchonously with help of the "Task".
            // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously.
            Task {
                // Checkout of the fact that we recieved a success and no errors
                guard success, error == nil else {
                    
                    // Failure of the attempt to check
                    print("Authentication has been failed")
                    self?.showAlert(title: "Failed to Authenticate", message: "Please try again")
                    return }
                
                // MARK: SEGUE TO THE MAIN SCREEN
                // 1. It can be a little function.
                let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
                self?.navigationController?.setViewControllers([viewController], animated: true)
            }
        }
    }
    
    // MARK: - UI Configuration
    
    // makeRounded(borderColour: .darkText, borderWidth: 1.0) for buttons
     
}
