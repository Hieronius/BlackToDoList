//
//  RegistrationViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var registrationEmailTextField: UITextField!
    @IBOutlet private weak var registrationNameTextField: UITextField!
    @IBOutlet private weak var registrationPasswordTextField: UITextField!
    @IBOutlet private weak var registrationSignUpButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some code here
    }
    
    // MARK: - IBActions
    
    /// method to pass and use data from ios Academy. I should refactor it with my own extensions after FireBase start to work correctly.
    @IBAction private func registrationSignUpButtonAction(_ sender: UIButton) {
        guard let email = registrationEmailTextField.text, !email.isEmpty,
              let password = registrationPasswordTextField.text, !password.isEmpty else {
            print("missing data")
            return
        }
        
        // Get auth instance
        // attempt sign in
        // if failure, present alert to create account
        // if user continues, create account
        
        // check sign in on app Launch
        // allow user to sign out with button
    }
}
