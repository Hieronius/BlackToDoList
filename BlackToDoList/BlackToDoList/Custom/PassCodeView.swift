//
//  PassCodeView.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 13.06.2023.
//

import UIKit
/// Custom class for passcode views.
final class PassCodeView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Define buttons as a circle.
        makeRounded(borderColour: .white, borderWidth: 1.0)
        // Define passcode view animation.
    }
    
}
