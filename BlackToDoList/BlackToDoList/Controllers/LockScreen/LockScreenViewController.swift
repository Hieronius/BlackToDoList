//
//  LockScreenViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit
import LocalAuthentication
import FirebaseAuth

final class LockScreenViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var createPasscodeLabel: UILabel!
    @IBOutlet weak var firstPasscodeTextFieldsStack: UIStackView!
    @IBOutlet weak var repeatPasscodeLabel: UILabel!
    @IBOutlet weak var secondPasscodeTextStack: UIStackView!
    @IBOutlet weak var wrongPasswordLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var firstPasscode = [Int]() {
        // When first passcode will be finished let's change label and passcode field.
        // MARK: I CAN PUT THIS CHUNK OF CODE INTO A SMALLER FUNCTION
        didSet {
            if firstPasscode.count == 4 {
                // Implement async task (can be TASK) because Property observer trying to reload UI to fast.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Reload UI.
                    self.createPasscodeLabel.isHidden.toggle()
                    self.firstPasscodeTextFieldsStack.isHidden.toggle()
                    self.repeatPasscodeLabel.isHidden.toggle()
                    self.secondPasscodeTextStack.isHidden.toggle()
                    
                    let currentPasscodeView = self.firstPasscodeTextFieldsStack.subviews
                    
                    for view in currentPasscodeView {
                        view.backgroundColor = UIColor.black
                        print("Passcode view has been cleaned")
                    }
                }
            } else {
                print("unexpected error with firstPasscode property observer")
            }
        }
    }

    private var secondPasscode = [Int]() {
        // When both passcodes are done we should check it on equality.
        // If the checkout has been failed let's clean both passcodes array and clean all animation.
        didSet {
            
            // MARK: PROBABLY SHOULD USE SWITCH
            // Checkout of passwords equality.
            if secondPasscode.count == 4 && firstPasscode.count == 4 {
                
                if firstPasscode != secondPasscode {
                    // Reload UI.
                    createPasscodeLabel.isHidden.toggle()
                    firstPasscodeTextFieldsStack.isHidden.toggle()
                    repeatPasscodeLabel.isHidden.toggle()
                    secondPasscodeTextStack.isHidden.toggle()
                    
                    print("First passcode is - \(firstPasscode)")
                    print("Second passcode is - \(secondPasscode)")
                    
                    // Clean all passcode views to it's original color.
                    print("Not equal passwords")
                    
                    // display a label "password is not correct"
                    // it can be a little function "displayLabelAndHide"
                    wrongPasswordLabel.isHidden.toggle()
                    
                    // Made an async work after a little time because property observer removing passwords before it's checkout for equality.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.firstPasscode.removeAll()
                        self.secondPasscode.removeAll()
                        
                        // Reload UI.
                        let currentPasscodeView = self.secondPasscodeTextStack.subviews
                        
                        for view in currentPasscodeView {
                            view.backgroundColor = UIColor.black
                            print("Passcode view has been cleaned")
                        }
                        
                        print("First passcode is - \(self.firstPasscode)")
                        print("Second passcode is - \(self.secondPasscode)")
                    }
                    
                    // Hide label "wrong password"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.wrongPasswordLabel.isHidden.toggle()
                    }
                    
                    // If password was equal, let's ask for FaceID/TouchID identification and move to the Main screen.
                    // MARK: PLACE FOR ALLERT - YOUR PASSWORD HAS BEEN SUCCESSFUL
                    // Place for the question to ask Tough ID/FaceID implementation.
                } else if firstPasscode == secondPasscode {
                    
                    // Seems like i need a custom alert controller with two buttons. First one "Ok" button should be with default closure and the second one "Cancel" with personal AlertControllerAction.
                    
                    let alertController = UIAlertController(title: "Passcode successfully created", message: "Give permission to use FaceID/TouchID ", preferredStyle: .alert)
                    
                    // User pressed "Ok" - save passcode, use Biometrics and redirect to the main screen.
                    let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                        
                        
                        // MARK: PUT HERE METHOD FOR FACEID/TOUCHID AUTHENTIFICATION IF USER OK WITH IT.
                        self.useBiometrics()
                        
                        print("Password has been created successfully")
                        
                        print("First passcode is - \(self.firstPasscode)")
                        print("Second passcode is - \(self.secondPasscode)")
                        
                        // Save user password. Without a little delay it trying to save an empty passcode array. Should be refactored.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                            // If passwords were equal let's save it to the keychain.
                            self?.savePasscode()
                            // Get password from the Keychain.
                            self?.getPasscode()
                            print("Programm checkpoint 2")
                        }
                        
                    }
                    // Add "Ok" button to the alert controller.
                    alertController.addAction(okAction)
                    
                    // User pressed "Cancel" - save passcode, don't use Biometrics and redirect to the main screen.
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                        
                        // MARK: USER CANCELED THE FACEID AUTHENTIFICATION AND REDIRECTED TO THE MAIN SCREEN.
                        let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
                        self.navigationController?.setViewControllers([viewController], animated: true)
                        
                        print("Password has been created successfully")
                        
                        print("First passcode is - \(self.firstPasscode)")
                        print("Second passcode is - \(self.secondPasscode)")
                        
                        // Save user password. Without a little delay it trying to save an empty passcode array. Should be refactored.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                            // If passwords were equal let's save it to the keychain.
                            self?.savePasscode()
                            // Get password from the Keychain.
                            self?.getPasscode()
                            print("Programm checkpoint 1")
                        }
                    }
                    
                    // Add "cancel" button to the alert controller
                    alertController.addAction(cancelAction)
                    // Present Alert Controller
                    self.present(alertController, animated: true)
                    
                    // Unexpected behavior
                    }  else {
                        print("Unexpected error with secondPasscode property observer")
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some core here
    }
    
    // MARK: - IBActions
    
    
    
    // MARK: ACTION TO ACTIVATE FACEID/TOUCHID OF THE USER
    @IBAction private func authenticationButtonAction(_ sender: Any) {
        // Create an abstractive model of the Apple Authentication Manager.
        let context = LAContext()
        
        // Create an abstractive model for possible Errors during the usage of the service.
        // Because this framework works with protocol NSErrorPointer and also it's a inout parameter.
        var error: NSError? = nil
        
        // Seems like it's a message which should ask User to use his TouchID.
        // Probably should be edited accordingly to variation that it can be FaceID check.
        let reason = "Please identify yourself"
        
        // MARK: ACTUAL FACEID/TOUCHID/DEFAULT IPHONE PIN CODE CHECKOUT WITH A SEGUE TO THE MAIN SCREEN IN CASE OF SUCCESS
        // context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { [weak self] success, error in
            
            // Do the job asynchonously with help of the "Task".
            // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously.
            Task {
                // Checkout of the fact that we recieved a success and no errors
                guard success, error == nil else {
                    
                    // Failure of the attempt to check
                    print("Authentication has been failed")
                    self?.showAlert(title: "Failed to Authenticate", message: "Please try again")
                    return }
                
                // MARK: SEGUE TO THE MAIN SCREEN
                // 1. It can be a little function.
                let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
                self?.navigationController?.setViewControllers([viewController], animated: true)
            }
        }
    }
    
    // MARK: LOGOUT FROM THE APP
    @IBAction func logOutButtonAction(_ sender: Any) {
        // Define an instance of FirebaseAuthorisation module
        let firebaseAuth = FirebaseAuth.Auth.auth()
        
        //  implement error handling while you wan't log out. Seems like it's need because there can be nil instead of user.
        do {
            try firebaseAuth.signOut()
            print("User has been logged out")
            
            // Place for a segue to the log in Screen.
            // MARK: Alert controller with confirmation can be used here.
            // 1. It can be a little function.
            let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            self.navigationController?.setViewControllers([viewController], animated: true)
            
        // Catch the error here.
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    // MARK: ENTER THE NUMBER FOR THE PASSWORD
    @IBAction func passcodeNumberPressed(_ sender: UIButton) {
        // Let's define a number which is equal to the button label.
        let number = Int(sender.titleLabel?.text ?? "0") ?? 0
        
        // If first passcode numbers array have enough place for numbers add number to the first passcode array and change color.
        if firstPasscode.count < 4 && secondPasscode.isEmpty {
            firstPasscode.append(number)
            // Select current element of passcode text field and change it's color after pressing the button.
            let currentPasscodeView = firstPasscodeTextFieldsStack.subviews[firstPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.white
            
            // Add special animation for the passcode view.
            // Increase it's size for a milдisecond and get it back.
            // Can be a little function.
            
            DispatchQueue.main.async {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            print("First passcode is - \(firstPasscode)")
            // There is a button label.
            print(sender.titleLabel?.text)
            
        // If a first passcode already filled and second passcode is still has less than 4 elements let's fill a second passcode array
        } else if firstPasscode.count == 4 && secondPasscode.count < 4 {
            secondPasscode.append(number)
            // Select current element of passcode text field and change it's color after pressing the button.
            let currentPasscodeView = secondPasscodeTextStack.subviews[secondPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.white
            
            // Animation for passcode view
            
            DispatchQueue.main.async {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            print("Second passcode is - \(secondPasscode)")
            // There is a button label.
            print(sender.titleLabel?.text)
        } else {
            print("Too much numbers")
        }
    }
    
    // MARK: DELETE A NUMBER FROM THE PASSWORD
    @IBAction func deletePasscodeButtonAction(_ sender: UIButton) {
        // If first passcode numbers array is not empty and a second one are empty let's remove one last element from first passcode array one by one.
        if firstPasscode.count > 0 && secondPasscode.isEmpty {
            let currentPasscodeView = firstPasscodeTextFieldsStack.subviews[firstPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.black
            
            // Animation for passcode view.
            DispatchQueue.main.async {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            firstPasscode.removeLast()
            print("First passcode is - \(firstPasscode)")
            print("button has been pressed")
            
        // If first passcode array are full we wan't remove elements from the second passcode array.
        } else if firstPasscode.count == 4 && secondPasscode.count < 4 {
            let currentPasscodeView = secondPasscodeTextStack.subviews[secondPasscode.count - 1]
            currentPasscodeView.backgroundColor = UIColor.black
            
            // Animation for passcode View
            
            DispatchQueue.main.async {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentPasscodeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            secondPasscode.removeLast()
            print("Second passcode is - \(secondPasscode)")
            print("button has been pressed")
        } else {
            print("no elements to remove")
        }
    }
    
    @IBAction func forgetPasswordButtonAction(_ sender: Any) {
        // Create an abstractive model of the Apple Authentication Manager.
        let context = LAContext()
        
        // Create an abstractive model for possible Errors during the usage of the service.
        // Because this framework works with protocol NSErrorPointer and also it's a inout parameter.
        var error: NSError? = nil
        
        // Seems like it's a message which should ask User to use his TouchID.
        // Probably should be edited accordingly to variation that it can be FaceID check.
        let reason = "Please identify yourself to clear an old passcode and create a new one"
        
        // MARK: ACTUAL FACEID/TOUCHID/DEFAULT IPHONE PASSWORD CHECKOUT. IS SUCCESS CLEAN THE OLD PASSCODE AND CREATE A NEW ONE
        // context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { [weak self] success, error in
            
            // Do the job asynchonously with help of the "Task".
            // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously.
            Task {
                // Checkout of the fact that we recieved a success and no errors
                guard success, error == nil else {
                    
                    // Failure of the attempt to check
                    print("Authentication has been failed")
                    self?.showAlert(title: "Failed to Authenticate", message: "Please try again")
                    return }
                
                // MARK: DELETE OLD PASSCODE AND CLEAN PASSCODE FIELDS VIEW PLUS PASSCODEARRAYS
                
                
            }
        }
    }
    
    // MARK: - Private Methods
    
    // Load the password from Keychain.
    // Convert String to the [Int] which is contain User passcode.
    private func getPasscode() {
        guard let data = KeychainManager.get(
            service: "BlackToDoList",
            account: "User10"
        ) else {
            print("Failed to read password")
            return
        }
        // Here we should convert from String to [Int] to get our passcode.
        let password = String(decoding: data, as: UTF8.self)
        print("This string we have got from Keychain - \(password)")
        
        // We wan't check each of a string elements of our password from Keychain.
        // If there a wrong format let's just skip this symbol.
        // MARK: Should be refactored.
        
        // Downcast our password as String to the actual passcode.
        // 1. Get access to the content inside "[]"
        // 2. Set a type of components which are we need.
        // 3. Use compact map to get non optional numbers
        let passcode = password.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        print("Read password: \(passcode)")
    }
    
    // Take passcode as [Int] and encrypt it with Keychain.
    private func savePasscode() {
        do {
            try KeychainManager.save(
                service: "BlackToDoList",
                account: "User10",
                // encode password with .utf8 encrypt code.
                // We wan't get an array of Int as a passcode and encrypt it as a string.
                password: "\(firstPasscode)".data(using: .utf8) ?? Data())
                print("Password - \(firstPasscode) has been saved to Keychain")
        
        } catch {
            print(error)
        }
    }
    
    private func useBiometrics() {
        // Create an abstractive model of the Apple Authentication Manager.
        let context = LAContext()
        
        // Create an abstractive model for possible Errors during the usage of the service.
        // Because this framework works with protocol NSErrorPointer and also it's a inout parameter.
        var error: NSError? = nil
        
        // Seems like it's a message which should ask User to use his TouchID.
        // Probably should be edited accordingly to variation that it can be FaceID check.
        let reason = "Please identify yourself"
        
        // MARK: ACTUAL FACEID/TOUCHID/DEFAULT IPHONE PIN CODE CHECKOUT WITH A SEGUE TO THE MAIN SCREEN IN CASE OF SUCCESS
        // context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { [weak self] success, error in
            
            // Do the job asynchonously with help of the "Task".
            // Because we ask Task to run it's work inside the UIButtonAction it will work in the MainThread but Asynchonously.
            Task {
                // Checkout of the fact that we recieved a success and no errors
                guard success, error == nil else {
                    
                    // Failure of the attempt to check
                    print("Authentication has been failed")
                    self?.showAlert(title: "Failed to Authenticate", message: "Please try again")
                    return }
                
                // MARK: SEGUE TO THE MAIN SCREEN
                // 1. It can be a little function.
                let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
                self?.navigationController?.setViewControllers([viewController], animated: true)
            }
        }
    }
    
    
    // MARK: - UI Configuration
    
     
}
