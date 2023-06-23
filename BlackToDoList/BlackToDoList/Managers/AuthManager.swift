//
//  RegistrationManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 22.06.2023.
//

import FirebaseAuth
import UIKit

final class AuthManager {
    
    static func signUp() {
        
    }
    
    static func signIn() {
        
    }
    
    static func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification()
    }
    
    static func logOut() {
        let firebaseAuth = FirebaseAuth.Auth.auth()
        
        // Check is there a real user in the syster with do-try-catch code.
        do {
            try firebaseAuth.signOut()
            print("Logout was completed successfully")
            // Don't know why we use NSError instead of just an Error.
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func resetPassword(_ email: String?, _ viewController: UIViewController) {
        
        
            // Check is our email text field empty.
            let email = email ?? ""
            
            // If email text field is empty throw an alert.
            if email.isEmpty {
                viewController.showAlert(title: "Empty field", message: "Email text field is empty")
                
                // If email is not valid throw an alert.
            } else if !viewController.isValidEmail(email) {
                viewController.showAlert(title: "Not valid email", message: "Please check and correct your email")
                
            } else {
                FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
                print("Email with a link to change your password has been send")
                // MARK: ALERT CONTROLLER - "LINK HAS BEEN SENT"
                // There should be redirection to the LogInScreen.
                viewController.showAlert(title: "Done",
                          message: "Please check your email address to create a new password)") {
                    viewController.navigationController?.popViewController(animated: true)
                }
            }
        }
}
