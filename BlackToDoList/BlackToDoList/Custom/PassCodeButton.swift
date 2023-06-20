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
        
        // Button fades out.
        DispatchQueue.main.async {
            sender.backgroundColor = .white
            sender.alpha = 0.9
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            sender.backgroundColor = .white
            sender.alpha = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            sender.backgroundColor = .white
            sender.alpha = 0.7
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07){
            sender.backgroundColor = .white
            sender.alpha = 0.6
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            sender.backgroundColor = .white
            sender.alpha = 0.5
        }
        
        // Button light up.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.backgroundColor = .black
            sender.alpha = 0.6
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
            sender.alpha = 0.7
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            sender.alpha = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
            sender.alpha = 0.9
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            sender.alpha = 1
        }
    }
}
