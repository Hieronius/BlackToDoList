//
//  MainScreenViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some code here
    }
    
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        do {
            try KeychainManager.deleteData(
                service: "BlackToDoList",
                account: "User1")
            print("Passcode has been deleted from Keychain")
        } catch {
            print("Delete account check point 2")
            print(error)
        }
    }
    
    @IBAction func enterPasscode(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "LockScreenViewController", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
            self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
}
