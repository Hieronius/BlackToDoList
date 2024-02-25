import UIKit

class PassCodeButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRounded(borderColour: .white, borderWidth: 1.0)
        self.addTarget(self, action: #selector(buttonClickedAnimation(sender: )), for: .touchUpInside)
    }
    
    
    /// Method creates an animation for "smooth" fade out and light up effect.
    /// - Parameter sender: representation of the tapped button.
    @objc private func buttonClickedAnimation(sender: UIButton) {
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
