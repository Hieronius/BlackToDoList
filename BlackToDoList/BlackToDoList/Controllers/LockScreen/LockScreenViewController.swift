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
    
    /// Array of first user passcode combination during registration.
    private var firstPasscode = [Int]() {
        didSet {
            switchPasscodes()
        }
    }
    
    /// Array of second user passcode combination during registration.
    private var secondPasscode = [Int]() {
        // When both passcodes are done we should check it on equality.
        // If the checkout has been failed let's clean both passcodes array and clean all animation.
        didSet {
            checkPasscodesForEqualityAndLogIn()
        }
    }
    
    private func checkPasscodesForEqualityAndLogIn() {
        DispatchQueue.main.async {
            if self.secondPasscode.count == 4 && self.firstPasscode.count == 4 {
                
                if self.firstPasscode != self.secondPasscode {
                    self.changePasscodesUI()
                    self.deleteWrongPasscodeWithDelay()
                    self.fillPasscodeField(self.secondPasscodeViewStack, .black)
                    self.openAndHideWrongPasscodeLabelWithDelay()
                    
                } else if self.firstPasscode == self.secondPasscode {
                    self.presentAlertToAskBiometricsPermission()
                }
            }
        }
    }
    
    private func fillPasscodeField(_ field: UIStackView, _ color: UIColor) {
        let currentPasscodeView = field.subviews
        
        for view in currentPasscodeView {
            view.backgroundColor = color
        }
    }
    
    private func deleteWrongPasscodeWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.firstPasscode.removeAll()
            self.secondPasscode.removeAll()
        }
    }
    
    private func openAndHideWrongPasscodeLabelWithDelay() {
        self.wrongPasscodeLabel.isHidden.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.wrongPasscodeLabel.isHidden.toggle()
        }
    }
    
    /**
     This private method is used to present an alert to the user asking for permission to use Face ID or Touch ID after successfully creating a passcode.

     **Functionality**
     
     - The method creates an instance of `UIAlertController` with a title and message to ask for biometrics permission.
     - It defines two actions for the alert controller: "Ok" and "Cancel".
     - The "Ok" action triggers the `askForBiometricsAndRedirectToMainScreen` method of `BiometricManager` to ask for biometrics permission and redirect to the main screen. It also sets `isUserGavePermissionToUseBiometrics` to `true`.
     - The "Cancel" action triggers the `segueToMainScreenAndMakeItAsRoot` method and also calls `saveUserPasccodeWithDelayAndChangeUserSessionStatus`.
     - Finally, the alert controller is presented to the user with animation.
     */
    private func presentAlertToAskBiometricsPermission() {
        let alertController = UIAlertController(title: "Passcode successfully created",
                                                message: "Give permission to use FaceID/TouchID ",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                BiometricManager.askForBiometricsAndRedirectToMainScreen(self)
                BiometricManager.isUserGavePermissionToUseBiometrics = true
            
            self.saveUserPasccodeWithDelayAndChangeUserSessionStatus()
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.segueToMainScreenAndMakeItAsRoot()
            self.saveUserPasccodeWithDelayAndChangeUserSessionStatus()
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func saveUserPasccodeWithDelayAndChangeUserSessionStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            do {
                try KeychainManager.saveData(service: KeychainManager.serviceId,
                                             account: KeychainManager.currentUser,
                                             password: self?.firstPasscode ?? [10, 10, 10, 10])
            } catch {
                print(error)
            }
            UserSessionManager.isUserLoggedIn = true
        }
    }
    // MARK: LAST PLACE FOR REFACTOR
    /// Current passcode combination when user wan't to LogIn to the app from new app session.
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
                // MARK: TRY TO USE ALREADY MADE FUNCTION TO HIDE AND OPEN "WRONG LABEL"
                wrongPasscodeLabel.isHidden = false
                print("Wrong passcode. Please try again")
                
                // Remove current passcode and clean passcode view. Let's enter passcode again.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.currentPasscode.removeAll()
                    
                    
                    // Reload UI. input type - 1. view: [View], 2. color: UIColor
                    self.fillPasscodeField(self.enterPasscodeViewStack, .black)
                    
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
        
        changeUIRegardsToUserSessionStatus()
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction private func useBiometricsButtonAction(_ sender: Any) {
            BiometricManager.askForBiometricsAndRedirectToMainScreen(self)
    }
    
    /**
     This function is an IBAction function that is triggered when the user taps the "Log Out" button in the app. It shows an alert to confirm if the user wants to log out, and if the user confirms, it logs the user out of the app, sets the "isUserLoggedIn" flag to false, and segues to the login screen.
    */
    @IBAction func logOutButtonAction(_ sender: Any) {
        showAlert(title: "LogOut",
                  message: "Are you sure to logout from the app?",
                  isCancelButton: true,
                  okButtonName: "Relogin") {
            AuthManager.logOut()
            UserSessionManager.isUserLoggedIn = false
            self.segueToLogInScreenAndMakeItAsRoot()
        }
    }
    
    /**
     This function is called when a number button is pressed in the passcode screen. It handles the logic for filling the passcode fields based on the user session status.
     
     - Parameters:
        - sender: paccode button that was pressed.
     
    **Functionality**
     
     1. The function takes the button label as an input and converts it to an integer.
     2. It checks the user session status to determine whether to fill the passcode field or create a new passcode.
     3. If the user is not logged in, it checks if the first passcode array has enough space for numbers. If so, it adds the number to the array and changes the color of the corresponding passcode field. If the first passcode is already filled and the second passcode still has space, it adds the number to the second passcode array. If there is no space for numbers, it prints "Too many numbers".
     4. If the user is logged in, it checks if the current passcode array has space for numbers. If so, it adds the number to the array and changes the color of the corresponding passcode field.
    */
    @IBAction func passcodeNumberPressed(_ sender: UIButton) {
        let number = Int(sender.titleLabel?.text ?? "0") ?? 0
        // MARK: SHOULD BE TESTED AND REFACTORED UNCORRECT COUNTER OF CURRENT NUMBERS/VIEW IN PASSCODE 28.06.23
        if !(UserSessionManager.isUserLoggedIn) {
            if firstPasscode.count < 4 && secondPasscode.isEmpty {
                firstPasscode.append(number)
                
                 testFillOfTheCurrentPasscodeView(firstPasscodeViewFieldsStack, firstPasscode, .white)
//                let currentPasscodeView = firstPasscodeViewFieldsStack.subviews[firstPasscode.count - 1]
//                currentPasscodeView.backgroundColor = UIColor.white
                
                // animatePasscodeView(view: currentPasscodeView)
                // animatePasscodeView(view: testFillOfTheCurrentPasscodeView(firstPasscodeViewFieldsStack, firstPasscode, .white))
                
            } else if firstPasscode.count == 4 && secondPasscode.count < 4 {
                secondPasscode.append(number)
                
                 testFillOfTheCurrentPasscodeView(secondPasscodeViewStack, secondPasscode, .white)
//                let currentPasscodeView = secondPasscodeViewStack.subviews[secondPasscode.count - 1]
//                currentPasscodeView.backgroundColor = UIColor.white
                
                // animatePasscodeView(view: currentPasscodeView)
                // animatePasscodeView(view: testFillOfTheCurrentPasscodeView(secondPasscodeViewStack, secondPasscode, .white))
            }
            
        } else {
            if currentPasscode.count < 4 {
                currentPasscode.append(number)
                
                 testFillOfTheCurrentPasscodeView(enterPasscodeViewStack, currentPasscode, .white)
                
//                let currentPasscodeView = enterPasscodeViewStack.subviews[currentPasscode.count - 1]
//                currentPasscodeView.backgroundColor = UIColor.white
                
                // animatePasscodeView(view: currentPasscodeView)
                // animatePasscodeView(view: testFillOfTheCurrentPasscodeView(enterPasscodeViewStack, currentPasscode, .white))
            }
        }
    }
    
    private func testFillOfTheCurrentPasscodeView(_ view: UIStackView, _ passcode: [Int], _ color: UIColor) {
        let currentPasscodeView = view.subviews[passcode.count - 1]
        currentPasscodeView.backgroundColor = UIColor.white
        animatePasscodeView(view: currentPasscodeView)
    }
    
    private func currentPasscodeViewIndex(_ indexes: [Int]) -> Int {
        return indexes.count - 1
    }
    
    private func fillSinglePasscodeView(_ view: UIView, _ color: UIColor) {
        view.backgroundColor = color
    }
    
    /**
     This method handles the action when the "delete passcode" button is pressed. It performs different actions based on the user's session status and the passcode arrays.
     
     - Parameter sender: The object that triggered the action.
     
     **Functionality**

     - If the user is not logged in, it checks the passcode arrays and removes the last element from the appropriate array. The function also updates the UI by changing the background color of the passcode view and triggers an asynchronous animation.

     - If the user is logged in, it checks the current passcode array and removes the last element if there are elements present. Similar to the previous case, it updates the UI and triggers the animation.

     - The method also prints debug information to the console for logging purposes
     */
    @IBAction func deletePasscodeButtonAction(_ sender: UIButton) {
        if !(UserSessionManager.isUserLoggedIn) {
            // MARK: SHOULD BE TESTED AND REFACTORED. UNCORRECT COUNTER OF CURRENT NUMBERS/VIEW IN PASSCODE 28.06.23
            if firstPasscode.count > 0 && firstPasscode.count < 4 && secondPasscode.isEmpty {
                firstPasscode.removeLast()
                let currentPasscodeView = firstPasscodeViewFieldsStack.subviews[firstPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.black
                
                animatePasscodeView(view: currentPasscodeView)
                // firstPasscode.removeLast()
                
            
            } else if firstPasscode.count == 4 && secondPasscode.count < 4 && secondPasscode.count > 0 {
                secondPasscode.removeLast()
                let currentPasscodeView = secondPasscodeViewStack.subviews[secondPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.black
                
                animatePasscodeView(view: currentPasscodeView)
                // secondPasscode.removeLast()
            }
            
        } else {
            if currentPasscode.count > 0 && currentPasscode.count <= 4  && firstPasscode.isEmpty {
                currentPasscode.removeLast()
                print(currentPasscode)
                let currentPasscodeView = enterPasscodeViewStack.subviews[currentPasscode.count - 1]
                currentPasscodeView.backgroundColor = UIColor.black
                
                animatePasscodeView(view: currentPasscodeView)
                // currentPasscode.removeLast()
            }
        }
    }
    
    /**
     This method displays an alert to the user, asking them to relogin in order to create a new passcode. It informs the user that the old passcode will be deleted. If the user confirms the action, the current passcode is deleted from the Keychain, the user session status is updated to "not logged in", and the user is redirected to the login screen.
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
    
    /**
     This private method is used to change the visibility of UI elements based on the user session status.

     **Functionality**
     
     - The method checks the user session status using the `isUserLoggedIn` property of the `UserSessionManager` class.
     - If the user is not logged in, it sets the `isHidden` property of certain UI elements to `false` to make them visible, while hiding other UI elements by setting their `isHidden` property to `true`.
     - If the user is logged in, it sets the `isHidden` property of certain UI elements to `true` to hide them, while making other UI elements visible by setting their `isHidden` property to `false`.
     */
    private func changeUIRegardsToUserSessionStatus() {
        if UserSessionManager.isUserLoggedIn == false {
           createPasscodeLabel.isHidden = false
           firstPasscodeViewFieldsStack.isHidden = false
           repeatPasscodeLabel.isHidden = true
           secondPasscodeViewStack.isHidden = true

           enterPasscodeLabel.isHidden = true
           enterPasscodeViewStack.isHidden = true
        
        } else if UserSessionManager.isUserLoggedIn == true {
           createPasscodeLabel.isHidden = true
           repeatPasscodeLabel.isHidden = true
           secondPasscodeViewStack.isHidden = true
           firstPasscodeViewFieldsStack.isHidden = true

           enterPasscodeLabel.isHidden = false
           enterPasscodeViewStack.isHidden = false
       }
    }
    
    // MARK: USER PASSCODE LOGIC BLOCK
    
    /// private function to change current user passcode phorm to fill during first registration.
    private func switchPasscodes() {
        if firstPasscode.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.changePasscodesUI()
                self.fillPasscodeField(self.firstPasscodeViewFieldsStack, .black)
            }
        }
    }
    
    private func changePasscodesUI() {
        createPasscodeLabel.isHidden.toggle()
        firstPasscodeViewFieldsStack.isHidden.toggle()
        repeatPasscodeLabel.isHidden.toggle()
        secondPasscodeViewStack.isHidden.toggle()
    }
    
    // MARK: - UI Configuration
    
    private func animatePasscodeView(view: UIView) {
        DispatchQueue.main.async {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
}
