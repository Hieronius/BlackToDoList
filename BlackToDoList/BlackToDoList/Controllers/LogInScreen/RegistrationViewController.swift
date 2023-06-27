//
//  RegistrationViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import FirebaseAuth

final class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var registrationEmailTextField: UITextField!
    @IBOutlet private weak var registrationPasswordTextField: UITextField!
    @IBOutlet private weak var registrationRepeatPasswordTextField: UITextField!
    @IBOutlet private weak var registrationSignUpButtonView: UIButton!
    
    // MARK: - Private Properties
    
    private let cleaningButton = CleaningButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - IBActions
    
    
    @IBAction private func registrationSignUpButtonAction(_ sender: UIButton) {
        Task {
            AuthManager.signUpAndMoveToTheLogInScreen(registrationEmailTextField.text,
                               registrationPasswordTextField.text,
                               registrationRepeatPasswordTextField.text,
                               self)
        }
    }
    
    // MARK: - UI Configuration

    private func setupUI() {
        setupRegistrationEmailTextField()
        setupRegistrationPasswordTextField()
        setupRegistrationRepeatPasswordTextField()
        setupregistrationSignUpButtonView()
    }
    
    private func setupRegistrationEmailTextField() {
        registrationEmailTextField.becomeFirstResponder()
        registrationEmailTextField.textContentType = .oneTimeCode
        registrationEmailTextField.rightView = cleaningButton
        registrationEmailTextField.rightViewMode = .whileEditing
        registrationEmailTextField.layer.cornerRadius = 15
        registrationEmailTextField.layer.masksToBounds = true
    }
    
    private func setupRegistrationPasswordTextField() {
        registrationPasswordTextField.textContentType = .oneTimeCode
        registrationPasswordTextField.rightView = cleaningButton
        registrationPasswordTextField.rightViewMode = .whileEditing
        registrationPasswordTextField.layer.cornerRadius = 15
        registrationPasswordTextField.layer.masksToBounds = true
    }
    
    private func setupRegistrationRepeatPasswordTextField() {
        registrationRepeatPasswordTextField.textContentType = .oneTimeCode
        registrationRepeatPasswordTextField.rightView = cleaningButton
        registrationRepeatPasswordTextField.rightViewMode = .whileEditing
        registrationRepeatPasswordTextField.layer.cornerRadius = 15
        registrationRepeatPasswordTextField.layer.masksToBounds = true
    }
    
    private func setupregistrationSignUpButtonView() {
        registrationSignUpButtonView.layer.cornerRadius = 15
    }
    
}
