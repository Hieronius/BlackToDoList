//
//  ViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

final class LogInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var LogInEmailTextField: UITextField!
    @IBOutlet private weak var LogInPasswordTextField: UITextField!
    
    @IBOutlet private weak var logInButtonView: UIButton!
    @IBOutlet private weak var signUpButtonView: UIButton!
    @IBOutlet private weak var resetPasswordButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func LogInButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    

}

