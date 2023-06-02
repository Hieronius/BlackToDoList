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
    
    @IBAction private func registrationSignUpButtonAction(_ sender: UIButton) {
    }
}
