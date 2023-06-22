//
//  RegistrationManager.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 22.06.2023.
//

import Foundation
import FirebaseAuth

final class AuthorisationManager {
    
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
    
    static func resetPassword(_ email: String) {
        
    }
}
