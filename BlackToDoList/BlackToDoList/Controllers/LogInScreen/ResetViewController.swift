//
//  ResetViewController.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

final class ResetViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resetEmailTextField: UITextField!
    @IBOutlet private weak var resetButtonView: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some code here
    }
    
    // MARK: - IBActions
    
    @IBAction private func resetPasswordButtonAction(_ sender: UIButton) {
    }
}
