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
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func resetPassword(_ email: String?, _ viewController: UIViewController) {
            let email = email ?? ""
            
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
