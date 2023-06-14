//
//  UIView+Extension.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

extension UIView {
    
    /// Изменяет св-во cornerRadius у view
    /// - Parameters:
    ///   - radius: Радиус угла закругления
    ///   - corners: Какие углы будут закруглены
    ///   - borderWidth: Ширина границы
    ///   - borderColor: Цвет границы
    func corneredRadius(radius: CGFloat? = nil,
                        corners: CACornerMask? = nil,
                        borderWidth: CGFloat? = nil,
                        borderColor: UIColor? = nil) {
        
        layer.cornerRadius = radius == nil ? bounds.height / 2 : radius!
        clipsToBounds = true
        
        if let corners = corners {
            layer.maskedCorners = corners
        }
        
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    func makeRounded(borderColour: UIColor, borderWidth: CGFloat) {
            layer.cornerRadius = (frame.size.width < frame.size.height) ? frame.size.width / 2.0 : frame.size.height / 2.0
            layer.borderColor = borderColour.cgColor
            layer.borderWidth = borderWidth
        }
    
}
