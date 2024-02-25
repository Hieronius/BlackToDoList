import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Define NavigationViewController  steck with LoginViewController as it's root view controller
        let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
        let navigationViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController

        navigationViewController.viewControllers = [rootViewController]
        
        /// Define this navigation view controller as root controller for UIWindow
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationViewController
        self.window = window
        window.makeKeyAndVisible()
        
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

