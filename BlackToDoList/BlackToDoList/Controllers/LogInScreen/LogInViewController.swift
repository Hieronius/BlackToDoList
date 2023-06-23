//
//  ViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import FirebaseAuth

final class LogInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logInEmailTextField: UITextField!
    @IBOutlet private weak var logInPasswordTextField: UITextField!
    @IBOutlet private weak var logInButtonView: UIButton!
    @IBOutlet private weak var toSignUpScreenButtonView: UIButton!
    @IBOutlet private weak var toResetPasswordScreenButtonView: UIButton!
    
    // MARK: - Private Properties
    
    private let cleaningButton = CleaningButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBActions
    
    
    // MARK: LOGIN AND CHECK IS USER EMAIL VEFIRFIED
    @IBAction private func logInButtonAction(_ sender: UIButton) {
        Task {
            AuthManager.signIn(logInEmailTextField.text,
                               logInPasswordTextField.text,
                               self)
        }
    }
    
    // MARK: - UI Configuration
    
    private func setupUI() {
        setupLogInEmailTextField()
        setupLogInPasswordTextField()
        setuplogInButtonView()
        setupToSignUpScreenButtonView()
        setupToResetPasswordScreenButtonView()
    }
    
    private func setupLogInEmailTextField() {
        logInEmailTextField.rightView = cleaningButton
        logInEmailTextField.rightViewMode = .whileEditing
        logInEmailTextField.textContentType = .oneTimeCode
        logInEmailTextField.layer.cornerRadius = 15
        logInEmailTextField.layer.masksToBounds = true
    }
    
    private func setupLogInPasswordTextField() {
        logInPasswordTextField.rightView = cleaningButton
        logInPasswordTextField.rightViewMode = .whileEditing
        logInPasswordTextField.textContentType = .oneTimeCode
        logInPasswordTextField.layer.cornerRadius = 15
        logInPasswordTextField.layer.masksToBounds = true
    }
    
    private func setuplogInButtonView() {
        logInButtonView.layer.cornerRadius = 15
    }
    
    private func setupToSignUpScreenButtonView() {
        toSignUpScreenButtonView.layer.cornerRadius = 15
    }
    
    private func setupToResetPasswordScreenButtonView() {
        toResetPasswordScreenButtonView.layer.cornerRadius = 15
    }
    
}
