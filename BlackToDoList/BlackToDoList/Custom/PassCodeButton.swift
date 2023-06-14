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
        makeRounded(borderColour: .white, borderWidth: 1.0)
    }
}
