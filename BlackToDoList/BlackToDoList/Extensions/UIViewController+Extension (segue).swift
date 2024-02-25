import UIKit

extension UIViewController {
    
    func segueToMainScreenAndMakeItRootVC(_ currentViewController: UIViewController) {
        Task {
            let storyboard = UIStoryboard(name: "MainScreenViewController", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
            currentViewController.navigationController?.setViewControllers([viewController], animated: true)
        }
    }
}
