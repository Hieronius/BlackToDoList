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
    
    /// The view rotates to a 180-degree angle (in radians) for 0.5 sec. and then rotates back to its original position continuously.
    private func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) { (completed) in
                self.animate()
            }
        }
    }
}
