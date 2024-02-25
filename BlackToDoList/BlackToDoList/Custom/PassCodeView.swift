import UIKit

final class PassCodeView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Define buttons as a circle.
        makeRounded(borderColour: .white, borderWidth: 1.0)
    }
    
}
