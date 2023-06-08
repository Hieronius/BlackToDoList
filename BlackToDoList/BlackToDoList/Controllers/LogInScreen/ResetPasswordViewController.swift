//
//  ResetViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import FirebaseAuth

final class ResetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resetPasswordEmailTextField: UITextField!
    @IBOutlet private weak var resetPasswordButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBActions
    
    
    // MARK: SEND LINK TO PASSWORD RESET TO THE EMAIL AND REDIRECT TO THE LOGIN SCREEN
    @IBAction private func resetPasswordButtonAction(_ sender: UIButton) {
        // Do the job asynchonously with help of the "Task".
        // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously.
        Task {
            // Check is our email text field empty.
            let email = resetPasswordEmailTextField.text ?? ""
            
            // If email text field is empty throw an alert.
            if email.isEmpty {
                showAlert(title: "Empty field", message: "Email text field is empty")
                
                // If email is not valid throw an alert.
            } else if !isValidEmail(email) {
                showAlert(title: "Not valid email", message: "Please check and correct your email")
                
            } else {
                FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
                print("Email with a link to change your password has been send")
                // MARK: ALERT CONTROLLER - "LINK HAS BEEN SENT"
                // There should be redirection to the LogInScreen.
                showAlert(title: "Done",
                          message: "Please check your email address to create a new password)") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setupUI() {
        setupResetPassEmailTextField()
    }
    
    private func setupResetPassEmailTextField() {
        resetPasswordEmailTextField.becomeFirstResponder()
    }
}
