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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some code here
    }
    
    // MARK: - IBActions
    
    // I should cut this method into a few little functions to:
    // 1. Check textfields.
    // 2. Create account.
    // 3. Send Email verification message.
    // 4. Force logout of new user.
    // MARK: CREATE A NEW ACCOUNT, VERIFY HIS EMAIL AND FORCE LOGOUT WITH REDIRECTION TO THE LOGIN SCREEN
    @IBAction private func registrationSignUpButtonAction(_ sender: UIButton) {
        // Do the job asynchonously with help of the "Task"
        // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously
        Task {
            
            // Check are all text fields not empty
            // 1. Probably it's a code for function "CheckTextFields"
            // MARK: PLACE FOR VERIFICATION ALERT CONTROLLER
            let email = registrationEmailTextField.text ?? ""
            let password = registrationPasswordTextField.text ?? ""
            let repeatPassword = registrationRepeatPasswordTextField.text ?? ""
            
            // Check is user password equal to "repeat password" phorm
            // 2. It can be another little function "IsPasswordCorrect"
            if password == repeatPassword {
                
                // MARK: Creation of new account with FirebaseAuth()
                // Use [weak self] as a referance to the current ViewController which we use for user data resouce
                // It's mean if we would delete this viewController or change it our creation function won't "hold" link to view controller
                // Also we wan't check the result of this method to throw a new account or an error to work with
                // 3. There can be the whole method to create a new account - "CreateNewAccount"
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] userAccount, error in
                    
                    // Check is our account has been created
                    guard let userAccount = self else { return}
                    
                    // MARK: PLACE FOR SUCCESS ACCOUNT CREATION WITH SEGUE TO THE LOGIN SCREEN
                    
                    // MARK: EMAIL VERIFICATION
                    // 4. Place for a little function to "verifyUserEmail"
                    Auth.auth().currentUser?.sendEmailVerification()
                    
                    // If creation of new account has been failed deal with an Error
                    guard error == nil else {
                        print("Account created has been failed")
                        // Error handling if the user tried to use already registered email
                        if error?.localizedDescription == "The email address is already in use by another account." {
                            print("Email already in use")
                        }
                        return
                    }
                    
                    // MARK: PLACE FOR "PLEASY VERIFY YOUR EMAIL" ALERT CONTROLLER
                    print("A new account was created successfuly")
                    
                    // MARK: FORCE LOGOUT OF THE CURRENT NEW USER AFTER HIS REGISTRATION
                    // 5. Place for a little function to "forceLogoutOfNewUser"
                    // May be i can use this chunk of code in the beginning of our method, because i need an instance of FirebaseAuth here and in newAccountCreation method
                    let firebaseAuth = FirebaseAuth.Auth.auth()
                    
                    // Check is there a real user in the syster with do-try-catch code
                    do {
                        try firebaseAuth.signOut()
                        print("Logout was completed successfully")
                        // Don't know why we use NSError instead of just an Error
                    } catch let signOutError {
                        print("Error signing out: %@", signOutError)
                    }
                }
                
            } else {
                //MARK: ALERT CONTROLLER "PLEASE CHECK YOUR PASSWORD"
                print("Wrong password")
            }
        }
    }
}
