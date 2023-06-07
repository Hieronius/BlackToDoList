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
    
    @IBOutlet private weak var LogInEmailTextField: UITextField!
    @IBOutlet private weak var LogInPasswordTextField: UITextField!
    @IBOutlet private weak var logInButtonView: UIButton!
    @IBOutlet private weak var toSignUpScreenButtonView: UIButton!
    @IBOutlet private weak var toResetPasswordScreenButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: LOGIN AND CHECK IS USER EMAIL VEFIRFIED
    @IBAction private func LogInButtonAction(_ sender: UIButton) {
        // Do the job asynchonously with help of the "Task"
        // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously
        Task {
            
            // Check are all text fields not empty
            let email = LogInEmailTextField.text ?? ""
            let password = LogInPasswordTextField.text ?? ""
            
            // Authorisation with email and password
            // Use [weak self] as a referance to the current ViewController which we use for user data resouce
            // It's mean if we would delete this viewController or change it our creation function won't "hold" link to view controller
            // Also we wan't check the result of this method to throw a new account or an error to work with
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] User, error in
                // Check is our account has been registered in the system
                guard let User = self else { return }
                
                guard error == nil else {
                    print("Wrong login or password")
                    return
                }
                
                // MARK: CHECK IS USER EMAIL WAS VERIFIED
                // 2. Can be cut to the little function "isEmailVerified()"
                if Auth.auth().currentUser?.isEmailVerified == true {
                    print("Welcome to the app")
                    print("User is verified")
                    
                    // MARK: SEGUE TO THE SECOND SCREEN
                    // 1. It can be a little function
                    let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
                    self?.navigationController?.setViewControllers([viewController], animated: true)
                    
                } else {
                    // MARK: ALERT CONTROLLER: "EMAIL MUST BE VERIFIED"
                    print("User still need to verify email")
                }
            }
        }
    }
    

}
