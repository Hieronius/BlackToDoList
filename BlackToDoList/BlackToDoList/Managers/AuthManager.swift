//
//  RegistrationManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 22.06.2023.
//

import FirebaseAuth
import UIKit

final class AuthManager {

    /**
    function is a static function that is used to sign up a new user with their email and password. This function takes four parameters: user's email address, user's password, user's password verification and the view controller that is calling the function. If user's email and password are correct this function should create a new account and send a verification link to the user's email address and redirect user to the LogIn Screen. Otherwice, it's shows an alert with an error message.
    
    - Parameters:
       - userEmail: A String that represents the user's email address. This parameter is optional and defaults to an empty string if it is not provided.
       - userPassword: A String that represents the user's password. This parameter is optional and defaults to an empty string if it is not provided.
       - repeatPassword: A String that represents the user's repeated password. This parameter is optional and defaults to an empty string if it is not provided.
       - currentViewController: A UIViewController that represents the current view controller. This parameter is required and must be provided when calling the function.
     */
    static func signUp(_ userEmail: String?,
                       _ userPassword: String?,
                       _ repeatPassword: String?,
                       _ currentViewController: UIViewController) {
        
        let email = userEmail ?? ""
        let password = userPassword ?? ""
        let repeatPassword = repeatPassword ?? ""
        
        if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
            currentViewController.showAlert(title: "Empty field", message: "One of a few feilds are empty")
            
        } else if !currentViewController.isValidEmail(email) {
            currentViewController.showAlert(title: "Not valid email", message: "Please check and correct your email")
            
        } else if password != repeatPassword {
            currentViewController.showAlert(title: "Passwords are not the same", message: "Please check your password")
            
        } else {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak currentViewController] userAccount, error in
                
                guard let userAccount = currentViewController else { return}
                
                Auth.auth().currentUser?.sendEmailVerification()
                
                guard error == nil else {
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        currentViewController?.showAlert(title: "Wrong Email", message: "Email has been already used")
                    }
                    return
                }
                currentViewController?.showAlert(title: "Account has been created",
                                         message: "Link to the account verification has been sent to your email address") {
                    currentViewController?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    /**
     This is a static function that allows a user to sign in to the app using their email and password. It takes in three parameters: the user's email address, the user's password, and the view controller that is calling the function. If the user's email and password are correct, and the user's email address is verified, the function segues to the Lock Screen view controller. Otherwise, it shows an alert with an error message.
    
     - Parameters:
       - userEmail: A String that represents the user's email address. This parameter is optional and defaults to an empty string if it is not provided.
       - userPassword: A String that represents the user's password. This parameter is optional and defaults to an empty string if it is not provided.
       - currentViewController: A UIViewController that represents the view controller that is calling the function.
     */
    static func signIn(_ userEmail: String?,
                       _ userPassword: String?,
                       _ currentViewController: UIViewController) {
        
        let email = userEmail ?? ""
        let password = userPassword ?? ""
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak currentViewController] User, error in
            guard let User = currentViewController else { return }
            
            guard error == nil else {
                currentViewController?.showAlert(title: "Account hasn't been found",
                                message: "Please check your email and password")
                return
            }
            
            if Auth.auth().currentUser?.isEmailVerified == true {
                
                let storyboard = UIStoryboard(name: "LockScreenViewController", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
                currentViewController?.navigationController?.setViewControllers([viewController], animated: true)
                
            } else {
                currentViewController?.showAlert(title: "Account is not verified",
                                message: "Please check your email address for verification")
            }
        }
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
    
    /**
     This is a static function that resets the password for a user's email address. It takes in two parameters: the user's email address and the view controller that is calling the function. If the email address is valid, the function sends a password reset email to the user's email address.
    
     - Parameters:
       - userEmail: A String value that represents the user's email address.
       - viewController: A UIViewController that represents the view controller that is calling the function
     */
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
