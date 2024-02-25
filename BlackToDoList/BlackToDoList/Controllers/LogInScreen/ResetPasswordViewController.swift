import UIKit
import FirebaseAuth

final class ResetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resetPasswordEmailTextField: UITextField!
    @IBOutlet private weak var resetPasswordButtonView: UIButton!
    
    // MARK: - Private Properties
    
    private let cleaningButton = CleaningButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBActions
    
    @IBAction private func resetPasswordButtonAction(_ sender: UIButton) {
        Task {
            AuthManager.resetPasswordAndGoToLogInScreen(resetPasswordEmailTextField.text, self)
        }
    }
    
    // MARK: - UI Configuration
    
    private func setupUI() {
        setupResetPassEmailTextField()
        setupResetPasswordButtonView()
    }
    
    private func setupResetPassEmailTextField() {
        resetPasswordEmailTextField.becomeFirstResponder()
        resetPasswordEmailTextField.rightView = cleaningButton
        resetPasswordEmailTextField.rightViewMode = .whileEditing
        resetPasswordEmailTextField.layer.cornerRadius = 15
        resetPasswordEmailTextField.layer.masksToBounds = true
    }
    
    private func setupResetPasswordButtonView() {
        resetPasswordButtonView.layer.cornerRadius = 15
    }
}
