//
//  RegistrationManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 22.06.2023.
//

import FirebaseAuth
import UIKit

final class AuthManager {
    
    static func signUp(_ userEmail: String?,
                       _ userPassword: String?,
                       _ repeatPassword: String?,
                       _ viewController: UIViewController) {
        // MARK: TEXT FIELDS VERIFICATION
        // Check are all text fields not empty.
        // 1. Probably it's a code for function "CheckTextFields".
        let email = userEmail ?? ""
        let password = userPassword ?? ""
        let repeatPassword = repeatPassword ?? ""
        
        // If some of the text fields are empty throw an alert controller.
        if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
            viewController.showAlert(title: "Empty field", message: "One of a few feilds are empty")
            
            // If email is not valid throw an alert controller.
        } else if !viewController.isValidEmail(email) {
            viewController.showAlert(title: "Not valid email", message: "Please check and correct your email")
            
            // If password and repeat password are different throw an alert controller.
        } else if password != repeatPassword {
            viewController.showAlert(title: "Passwords are not the same", message: "Please check your password")
            
            // If all conditions has been checked successfully let's proceed to the user registration.
        } else {
            // MARK: Creation of new account with FirebaseAuth()
            // Use [weak self] as a referance to the current ViewController which we use for user data resouce.
            // It's mean if we would delete this viewController or change it our creation function won't "hold" link to view controller.
            // Also we wan't check the result of this method to throw a new account or an error to work with.
            // 3. There can be the whole method to create a new account - "CreateNewAccount".
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak viewController] userAccount, error in
                
                // Check is our account has been created.
                guard let userAccount = viewController else { return}
                
                // MARK: PLACE FOR SUCCESS ACCOUNT CREATION WITH SEGUE TO THE LOGIN SCREEN
                
                // MARK: EMAIL VERIFICATION
                // 4. Place for a little function to "verifyUserEmail".
                Auth.auth().currentUser?.sendEmailVerification()
                
                // If creation of new account has been failed deal with an Error.
                guard error == nil else {
                    print("Account created has been failed")
                    // Error handling if the user tried to use already registered email.
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        viewController?.showAlert(title: "Wrong Email", message: "Email has been already used")
                    }
                    return
                }
                
                // MARK: PLACE FOR "PLEASE VERIFY YOUR EMAIL" ALERT CONTROLLER
                print("A new account was created successfuly")
                viewController?.showAlert(title: "Account has been created",
                                         message: "Link to the account verification has been sent to your email address") {
                    // Back to the LogIn screen if our registration was successful.
                    viewController?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    static func signIn() {
        
    }
    
    static func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification()
    }
    
    static func logOut() {
        let firebaseAuth = FirebaseAuth.Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func resetPassword(_ userEmail: String?, _ viewController: UIViewController) {
            let email = userEmail ?? ""
            
            if email.isEmpty {
                viewController.showAlert(title: "Empty field", message: "Email text field is empty")
                
            } else if !viewController.isValidEmail(email) {
                viewController.showAlert(title: "Not valid email", message: "Please check and correct your email")
                
            } else {
                FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
                viewController.showAlert(title: "Done",
                          message: "Please check your email address to create a new password)") {
                    viewController.navigationController?.popViewController(animated: true)
                }
            }
        }
}
