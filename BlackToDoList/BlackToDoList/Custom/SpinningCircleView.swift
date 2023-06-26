//
//  NoInternetSpinner.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 26.06.2023.
//

import UIKit

final class SpinningCircleView: UIView {
    
    let spinningCircle = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.white.cgColor
        spinningCircle.lineWidth = 10
        spinningCircle.strokeEnd = 0.25
        spinningCircle.lineCap = .round
        
        // Should use anchors to reach the middle of the screen.
        // spinningCircle.frame = CGRect(x: 50, y: 50, width: 10, height: 10)
        
        self.layer.addSublayer(spinningCircle)
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) { (completed) in
                self.animate()
            }
        }
    }
}
