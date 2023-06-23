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
    
    // MARK: - Private Properties
    
    private let cleaningButton = CleaningButton()
    
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
            AuthManager.resetPassword(resetPasswordEmailTextField.text, self)
        }
    }
    
    // MARK: - UI Configuration
    
    private func setupUI() {
        setupResetPassEmailTextField()
        setupResetPasswordButtonView()
    }
    
    private func setupResetPassEmailTextField() {
        resetPasswordEmailTextField.becomeFirstResponder()
        resetPasswordEmailTextField.rightView = cleaningButton
        resetPasswordEmailTextField.rightViewMode = .whileEditing
        resetPasswordEmailTextField.layer.cornerRadius = 15
        resetPasswordEmailTextField.layer.masksToBounds = true
    }
    
    private func setupResetPasswordButtonView() {
        resetPasswordButtonView.layer.cornerRadius = 15
    }
}
