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
        // Do the job asynchonously with help of the "Task".
        // Because we ask Task to run it's work inside the UIButtonAction it will run in the MainThread but Asynchonously (in background).
        Task {
            
            // Check are all text fields not empty.
            let email = logInEmailTextField.text ?? ""
            let password = logInPasswordTextField.text ?? ""
            
            // Authorisation with email and password.
            // Use [weak self] as a referance to the current ViewController which we use for user data resouce.
            // It's mean if we would delete this viewController or change it our creation function won't "hold" link to view controller.
            // Also we wan't check the result of this method to throw a new account or an error to work with.
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] User, error in
                // Check is our account has been registered in the system.
                guard let User = self else { return }
                
                guard error == nil else {
                    self?.showAlert(title: "Account hasn't been found",
                                    message: "Please check your email and password")
                    print("Wrong login or password")
                    return
                }
                
                // MARK: CHECK IS USER EMAIL WAS VERIFIED
                // 2. Can be cut to the little function "isEmailVerified()".
                if Auth.auth().currentUser?.isEmailVerified == true {
                    print("Welcome to the app")
                    print("User is verified")
                    
                    // MARK: SEGUE TO THE SECOND SCREEN
                    // 1. It can be a little function.
                    let storyboard = UIStoryboard(name: "LockScreenViewController", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
                    self?.navigationController?.setViewControllers([viewController], animated: true)
                    
                } else {
                    // MARK: ALERT CONTROLLER: "EMAIL MUST BE VERIFIED"
                    print("User still need to verify email")
                    self?.showAlert(title: "Account is not verified",
                                    message: "Please check your email address for verification")
                }
            }
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
