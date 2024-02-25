import UIKit
/// Custom cleaning button for any text fields where you need to remove some text.
final class CleaningButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCleaningButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupCleaningButton() {
        setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        tintColor = .black
        widthAnchor.constraint(equalToConstant: 30).isActive = true
        addTarget(self, action: #selector(clearTextField(sender: )), for: .touchUpInside)
    }
    
    @objc private func clearTextField(sender: UIButton) {
        if let textField = sender.superview as? UITextField {
            textField.text = ""
        }
    }

    
}
