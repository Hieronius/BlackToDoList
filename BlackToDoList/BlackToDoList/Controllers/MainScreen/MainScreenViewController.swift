import UIKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        do {
            try KeychainManager.deleteData(
                service: "BlackToDoList",
                account: "User1")
            print("Passcode has been deleted from Keychain")
        } catch {
            print("Delete account check point 2")
            print(error)
        }
    }
    
    @IBAction func enterPasscode(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "LockScreenViewController", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
            self.navigationController?.setViewControllers([viewController], animated: true)

    }
    
}
