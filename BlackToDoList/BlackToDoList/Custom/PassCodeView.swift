//
//  PassCodeView.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 13.06.2023.
//

import UIKit
/// Custom class for passcode views.
final class PassCodeView: UIView {
    // Change it's appearance when the user can see the screen.
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRounded(borderColour: .white, borderWidth: 1.0)
    }
    
 
}
