//
//  LockScreenViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

final class LockScreenViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var createPasscodeLabel: UILabel!
    @IBOutlet weak var firstPasscodeViewFieldsStack: UIStackView!
    
    @IBOutlet weak var repeatPasscodeLabel: UILabel!
    @IBOutlet weak var secondPasscodeViewStack: UIStackView!
    
    @IBOutlet weak var enterPasscodeViewStack: UIStackView!
    @IBOutlet weak var enterPasscodeLabel: UILabel!
    
    @IBOutlet weak var wrongPasscodeLabel: UILabel!
    
    @IBOutlet weak var useBiometricsButtonView: UIButton! {
        didSet {
            hideBiometricsButtonIfUserWontGivePermission()
        }
    }
    
    // MARK: - Private Properties
    
    // Array of first user passcode combination during registration.
    private var firstPasscode = [Int]() {
        // When first passcode will be finished let's change label and passcode field.
        // MARK: I CAN PUT THIS CHUNK OF CODE INTO A SMALLER FUNCTION
        didSet {
            if firstPasscode.count == 4 {
                // Implement async task (can be TASK) because Property observer trying to reload UI to fast.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Reload UI.
                    self.createPasscodeLabel.isHidden.toggle()
                    self.firstPasscodeViewFieldsStack.isHidden.toggle()
                    self.repeatPasscodeLabel.isHidden.toggle()
                    self.secondPasscodeViewStack.isHidden.toggle()
                    
                    let currentPasscodeView = self.firstPasscodeViewFieldsStack.subviews
                    
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
    // Array of second user passcode combination during registration.
    private var secondPasscode = [Int]() {
        // When both passcodes are done we should check it on equality.
        // If the checkout has been failed let's clean both passcodes array and clean all animation.
        didSet {
            DispatchQueue.main.async {
                // MARK: PROBABLY SHOULD USE SWITCH
                // Checkout of passwords equality.
                if self.secondPasscode.count == 4 && self.firstPasscode.count == 4 {
                    
                    if self.firstPasscode != self.secondPasscode {
                        // Reload UI.
                        self.createPasscodeLabel.isHidden.toggle()
                        self.firstPasscodeViewFieldsStack.isHidden.toggle()
                        self.repeatPasscodeLabel.isHidden.toggle()
                        self.secondPasscodeViewStack.isHidden.toggle()
                        
                        print("First passcode is - \(self.firstPasscode)")
                        print("Second passcode is - \(self.secondPasscode)")
                        
                        // Clean all passcode views to it's original color.
                        print("Not equal passwords")
                        
                        // display a label "password is not correct"
                        // it can be a little function "displayLabelAndHide"
                        self.wrongPasscodeLabel.isHidden.toggle()
                        
                        // Made an async work after a little time because property observer removing passwords before it's checkout for equality.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.firstPasscode.removeAll()
                            self.secondPasscode.removeAll()
                            
                            // Reload UI.
                            let currentPasscodeView = self.secondPasscodeViewStack.subviews
                            
                            for view in currentPasscodeView {
                                view.backgroundColor = UIColor.black
                                print("Passcode view has been cleaned")
                            }
                            
                            print("First passcode is - \(self.firstPasscode)")
                            print("Second passcode is - \(self.secondPasscode)")
                        }
                        
                        // Hide label "wrong password"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.wrongPasscodeLabel.isHidden.toggle()
                        }
                        
                        // If password was equal, let's ask for FaceID/TouchID identification and move to the Main screen.
                        // MARK: PLACE FOR ALLERT - YOUR PASSWORD HAS BEEN SUCCESSFUL
                        // Place for the question to ask Tough ID/FaceID implementation.
                    } else if self.firstPasscode == self.secondPasscode {
                        
                        // Seems like i need a custom alert controller with two buttons. First one "Ok" button should be with default closure and the second one "Cancel" with personal AlertControllerAction.
                        
                        let alertController = UIAlertController(title: "Passcode successfully created", message: "Give permission to use FaceID/TouchID ", preferredStyle: .alert)
                        
                        // User pressed "Ok" - save passcode, use Biometrics and redirect to the main screen.
                        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                            
                            
                            // MARK: PUT HERE METHOD FOR FACEID/TOUCHID AUTHENTIFICATION IF USER OK WITH IT.
                                BiometricManager.askForBiometricsAndRedirectToMainScreen(self)
                                BiometricManager.isUserGavePermissionToUseBiometrics = true
                            
                            
                            print("Password has been created successfully")
                            
                            print("First passcode is - \(self.firstPasscode)")
                            print("Second passcode is - \(self.secondPasscode)")
                            
                            // Save user password. Without a little delay it trying to save an empty passcode array. Should be refactored.
                            // MARK: Can be replaced with a small function.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                                // If passwords were equal let's save it to the keychain.
                                do {
                                    try KeychainManager.saveData(service: KeychainManager.serviceId,
                                                                 account: KeychainManager.currentUser,
                                                                 password: self?.firstPasscode ?? [0, 0, 0, 0])
                                } catch {
                                    print(error)
                                }
                                
                                // Get password from the Keychain.
                                // self?.getPasscode()
                                
                                do {
                                    try KeychainManager.getData(service: KeychainManager.serviceId, account: KeychainManager.currentUser)
                                } catch {
                                    print(error)
                                }
                                // print("\(self?.getPasscode())) has been saved")
                                // Set status of the current user session to true
                                UserSessionManager.isUserLoggedIn = true
                                print("Current status of user session - \(UserSessionManager.isUserLoggedIn = true)")
                                print("Programm checkpoint 2")
                            }
                            
                        }
                        // Add "Ok" button to the alert controller.
                        alertController.addAction(okAction)
                        
                        // User pressed "Cancel" - save passcode, don't use Biometrics and redirect to the main screen.
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                            
                            // MARK: USER CANCELED THE FACEID AUTHENTIFICATION AND REDIRECTED TO THE MAIN SCREEN.
                            self.segueToMainScreenAndMakeItAsRoot()
                            
                            print("Password has been created successfully")
                            
                            print("First passcode is - \(self.firstPasscode)")
                            print("Second passcode is - \(self.secondPasscode)")
                            
                            // Save user password. Without a little delay it trying to save an empty passcode array. Should be refactored.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                                // If passwords were equal let's save it to the keychain.
                                do {
                                    try KeychainManager.saveData(service: KeychainManager.serviceId,
                                                                 account: KeychainManager.currentUser,
                                                                 password: self?.firstPasscode ?? [0, 0, 0, 0])
                                } catch {
                                    print(error)
                                }
                                // Get password from the Keychain.
                                // self?.getPasscode()
                                do {
                                    try KeychainManager.getData(service: KeychainManager.serviceId, account: KeychainManager.currentUser)
                                } catch {
                                    print(error)
                                }
                                
                                // Set status of the current user session to true
                                UserSessionManager.isUserLoggedIn = true
                                print("Current status of user session - \(UserSessionManager.isUserLoggedIn)")
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
    }
    // Current passcode combination when user wan't to LogIn to the app from new app session.
    private var currentPasscode = [Int]() {
        didSet {
            // If passcode was correct let's redirect user into the main screen.
            var passcodeFromKeychain = [Int]()
            // may be i should put these little chunks of code into the little functions
            do {
                passcodeFromKeychain = try KeychainManager.getData(service: KeychainManager.serviceId,
                                                                   account: KeychainManager.currentUser) ?? [0, 0, 0, 0]
            } catch {
                print(error)
            }
            if currentPasscode.count == 4 && currentPasscode == passcodeFromKeychain {
                segueToMainScreenAndMakeItAsRoot()
                UserSessionManager.isUserLoggedIn = true
                print("Welcome to the app")
            } else if currentPasscode.count == 4 && currentPasscode != passcodeFromKeychain {
                // If passcode was wrong let's delete all numbers and views and try again.
                wrongPasscodeLabel.isHidden = false
                print("Wrong passcode. Please try again")
                
                // Remove current passcode and clean passcode view. Let's enter passcode again.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.currentPasscode.removeAll()
                    
                    // Reload UI.
                    let currentPasscodeView = self.enterPasscodeViewStack.subviews
                    
                    for view in currentPasscodeView {
                        view.backgroundColor = UIColor.black
                        print("Passcode view has been cleaned")
                    }
                    
                    print("Current passcode is - \(self.currentPasscode)")
                }
                // Hide label "wrong password" after a little while.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.wrongPasscodeLabel.isHidden.toggle()
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test of user current session
        checkCurrentUserSession()
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction private func useBiometricsButtonAction(_ sender: Any) {
            BiometricManager.askForBiometricsAndRedirectToMainScreen(self)
    }
    
    /// This function is an IBAction function that is triggered when the user taps the "Log Out" button in the app. It shows an alert to confirm if the user wants to log out, and if the user confirms, it logs the user out of the app, sets the "isUserLoggedIn" flag to false, and segues to the login screen.
    /// - Parameters:
    ///     - sender: An object that represents the sender of the action.
    /// - Returns: This function does not return any value.
    @IBAction func logOutButtonAction(_ sender: Any) {
        showAlert(title: "LogOut", message: "Are you sure to logout from the app?", isCancelButton: true, okButtonName: "Relogin") {
            AuthManager.logOut()
            print("User has been logged out")
            UserSessionManager.isUserLoggedIn = false
            self.segueToLogInScreenAndMakeItAsRoot()
        }
    }
    
    // Need documentation.
    @IBAction func passcodeNumberPressed(_ sender: UIButton) {
        // Let's define a number which is equal to the button label.
        let number = Int(sender.titleLabel?.text ?? "0") ?? 0
        
        // Check of the current user session status. If loggen in fill the passcode field "Enter the passcode". If not let's create a new one.
        if !(UserSessionManager.isUserLoggedIn) {
            // If first passcode numbers array have enough place for numbers add number to the first passcode array and change color.
            if firstPasscode.count < 4 && secondPasscode.isEmpty {
                firstPasscode.append(number)
                // Select current element of passcode text field and change it's color after pressing the button.
                let currentPasscodeView = firstPasscodeViewFieldsStack.subviews[firstPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.white
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                print("First passcode is - \(firstPasscode)")
                // There is a button label.
                print(sender.titleLabel?.text)
                
                // If a first passcode already filled and second passcode is still has less than 4 elements let's fill a second passcode array
            } else if firstPasscode.count == 4 && secondPasscode.count < 4 {
                secondPasscode.append(number)
                // Select current element of passcode text field and change it's color after pressing the button.
                let currentPasscodeView = secondPasscodeViewStack.subviews[secondPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.white
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                
                print("Second passcode is - \(secondPasscode)")
                // There is a button label.
                print(sender.titleLabel?.text)
            } else {
                print("Too much numbers")
            }
        } else {
            if currentPasscode.count < 4 {
                currentPasscode.append(number)
                // Select current element of passcode text field and change it's color after pressing the button.
                let currentPasscodeView = enterPasscodeViewStack.subviews[currentPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.white
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                print("Current passcode is - \(currentPasscode)")
                // There is a button label.
                print(sender.titleLabel?.text)
            }
        }
    }   
    
    /**
     This method handles the action when the "delete passcode" button is pressed. It performs different actions based on the user's session status and the passcode arrays.
     
     - Parameter sender: The object that triggered the action.

     If the user is not logged in, it checks the passcode arrays and removes the last element from the appropriate array. The function also updates the UI by changing the background color of the passcode view and triggers an asynchronous animation.

     If the user is logged in, it checks the current passcode array and removes the last element if there are elements present. Similar to the previous case, it updates the UI and triggers the animation.

     The method also prints debug information to the console for logging purposes
     */
    @IBAction func deletePasscodeButtonAction(_ sender: UIButton) {
        // Need to be cleaned.
        // Check of the current user session status. If loggen in fill the passcode field "Enter the passcode". If not let's create a new one.
        if !(UserSessionManager.isUserLoggedIn) {
            
            // If first passcode numbers array is not empty and a second one are empty let's remove one last element from first passcode array one by one.
            if firstPasscode.count > 0 && secondPasscode.isEmpty {
                let currentPasscodeView = firstPasscodeViewFieldsStack.subviews[firstPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.black
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                
                firstPasscode.removeLast()
                print("First passcode is - \(firstPasscode)")
                print("button has been pressed")
                
                // If first passcode array are full we wan't remove elements from the second passcode array.
            } else if firstPasscode.count == 4 && secondPasscode.count < 4 {
                let currentPasscodeView = secondPasscodeViewStack.subviews[secondPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.black
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                
                secondPasscode.removeLast()
                print("Second passcode is - \(secondPasscode)")
                print("button has been pressed")
            } else {
                print("no elements to remove")
            }
        } else {
            if currentPasscode.count > 0 && currentPasscode.count <= 4  {
                print("delete enter passcode number")
                currentPasscode.removeLast()
                // Select current element of passcode text field and change it's color after pressing the button.
                let currentPasscodeView = enterPasscodeViewStack.subviews[currentPasscode.count]
                currentPasscodeView.backgroundColor = UIColor.black
                
                activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: currentPasscodeView)
                print("Current passcode is - \(currentPasscode)")
                // There is a button label.
                print(sender.titleLabel?.text)
            } else {
                print("no elements to remove")
            }
        }
    }
    
    /**
     This method displays an alert to the user, asking them to relogin in order to create a new passcode. It informs the user that the old passcode will be deleted. If the user confirms the action, the current passcode is deleted from the Keychain, the user session status is updated to "not logged in", and the user is redirected to the login screen.

     - Parameter sender: The object that triggered the action.
     */
    @IBAction func forgetPasswordButtonAction(_ sender: Any) {
        showAlert(title: "Please relogin to create a new passcode",
                  message: "Old passcode will be deleted. Are you sure to procedure?",
                  isCancelButton: true,
                  okButtonName: "Relogin") {
            
            do {
                try KeychainManager.deleteData(service: KeychainManager.serviceId,
                                               account: KeychainManager.currentUser)
            } catch {
                print(KeychainManager.KeychainError.unknown(OSStatus()))
            }
            UserSessionManager.isUserLoggedIn = false
            self.segueToLogInScreenAndMakeItAsRoot()
        }
        
    }
    
    private func hideBiometricsButtonIfUserWontGivePermission() {
        DispatchQueue.main.async {
            if BiometricManager.isUserGavePermissionToUseBiometrics {
                self.useBiometricsButtonView.isHidden = false
            } else {
                self.useBiometricsButtonView.isHidden = true
            }
        }
    }
    
    private func segueToMainScreenAndMakeItAsRoot() {
        let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func segueToLogInScreenAndMakeItAsRoot() {
        let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func checkCurrentUserSession() {
        
        // USER IS NOT LOGGED TO THE APP (FALSE).
        if UserSessionManager.isUserLoggedIn == false {
           createPasscodeLabel.isHidden = false
           firstPasscodeViewFieldsStack.isHidden = false
           repeatPasscodeLabel.isHidden = true
           secondPasscodeViewStack.isHidden = true

           enterPasscodeLabel.isHidden = true
           enterPasscodeViewStack.isHidden = true
           
           print("USER IS NOT LOGGED IN. YOU SHOULD CREATE A NEW PASSWORD")

       // USER ALREADY INSIDE THE APP.
        } else if UserSessionManager.isUserLoggedIn == true {
           createPasscodeLabel.isHidden = true
           repeatPasscodeLabel.isHidden = true
           secondPasscodeViewStack.isHidden = true
           firstPasscodeViewFieldsStack.isHidden = true

           enterPasscodeLabel.isHidden = false
           enterPasscodeViewStack.isHidden = false

           print("USER IS ALREADY INSIDE THE APP. JUST ENTER THE PASSCODE")
       }
    }
    
    // MARK: - UI Configuration
    
    // Can be expanded with repeating code from the main function.
    private func activateAsyncAnimationForPasscodeViewAfterBeingFilled(view: UIView) {
        // Animation for passcode view.
        DispatchQueue.main.async {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
}
