//
//  LockScreenViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import LocalAuthentication

final class LockScreenViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var createPasscodeLabel: UILabel!
    @IBOutlet weak var firstPasscodeTextFieldsStack: UIStackView!
    @IBOutlet weak var repeatPasscodeLabel: UILabel!
    @IBOutlet weak var secondPasscodeTextStack: UIStackView!
    
    // MARK: - Private Properties
    
    private var firstPasscode = [Int]()
    private var secondPasscode = [Int]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some core here
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: ACTION TO ACTIVATE FACEID/TOUCHID OF THE USER
    @IBAction private func authenticationButtonAction(_ sender: Any) {
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
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        createPasscodeLabel.isHidden.toggle()
        firstPasscodeTextFieldsStack.isHidden.toggle()
        repeatPasscodeLabel.isHidden.toggle()
        secondPasscodeTextStack.isHidden.toggle()
        
    }
    
    @IBAction func passcodeNumberPressed(_ sender: UIButton) {
        // Let's define a number which is equal to the button label.
        let number = Int(sender.titleLabel?.text ?? "0") ?? 0
        
        // If passcode numbers array have enough place for numbers add number to the passcode array and change color.
        if firstPasscode.count < 5 {
            firstPasscode.append(number)
            // Select current element of passcode text field and change it's color after pressing the button.
            let currentPasscodeView = firstPasscodeTextFieldsStack.subviews[firstPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.white
            print(firstPasscode)
            // There is a button label.
            print(sender.titleLabel?.text)
        } else {
            print("Too much numbers")
        }
    }
    
    @IBAction func deletePasscodeButtonAction(_ sender: UIButton) {
        // If passcode numbers array is not empty remove one last element by one tap.
        if firstPasscode.count > 0 {
            let currentPasscodeView = firstPasscodeTextFieldsStack.subviews[firstPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.black
            firstPasscode.removeLast()
            print(firstPasscode)
            print("button has been pressed")
        } else {
            print("no elements to remove")
        }
    }
    
    
    
    // MARK: - UI Configuration
    
     
}
