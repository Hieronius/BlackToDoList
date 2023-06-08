//
//  ResetViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import FirebaseAuth

final class ResetViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resetEmailTextField: UITextField!
    @IBOutlet private weak var resetButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some code here
    }
    
    // MARK: - IBActions
    
    
    // MARK: SEND LINK TO PASSWORD RESET TO THE EMAIL AND REDIRECT TO THE LOGIN SCREEN
    @IBAction private func resetPasswordButtonAction(_ sender: UIButton) {
        // Do the job asynchonously with help of the "Task"
        // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously
        Task {
            // Check is our email text field empty
            let email = resetEmailTextField.text ?? ""
            
            FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
            print("Email with a link to change your password has been send")
            // MARK: ALERT CONTROLLER - "LINK HAS BEEN SENT"
            // There should be redirection to the LogInScreen
            showAlert(title: "Done",
                      message: "Please check your email address to create a new password)") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
