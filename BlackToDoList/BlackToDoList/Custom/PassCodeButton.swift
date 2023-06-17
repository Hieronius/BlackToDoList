//
//  PassCodeButton.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 13.06.2023.
//

import UIKit
/// Custom class for pass code numbers buttons to press.
class PassCodeButton: UIButton {
     // Change it's appearance when the user can see the screen.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Define buttons as a circle.
        makeRounded(borderColour: .white, borderWidth: 1.0)
        // Define animation after initialization of the button.
        self.addTarget(self, action: #selector(buttonClickedAnimation(sender: )), for: .touchUpInside)
    }
    
    // Add Animation to the button.
    @objc private func buttonClickedAnimation(sender: UIButton) {
        DispatchQueue.main.async {
            sender.alpha = 0.5
            sender.backgroundColor = .white
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.backgroundColor = .black
            sender.alpha = 0.6
            sender.alpha = 0.7
            sender.alpha = 0.8
            sender.alpha = 0.9
            sender.alpha = 1.0
        }
    }
}
