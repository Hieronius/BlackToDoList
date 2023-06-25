//
//  SceneDelegate.swift
//  BlackToDoList
//
//  Created by Арсентий Халимовский on 30.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        NetworkMonitorManager.shared.startMonitoring()
        print("Start to monitor a current connection status")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Define NavigationViewController  steck with LoginViewController as it's root view controller
//        let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "LockScreenViewController", bundle: nil)
        let navigationViewController = storyboard.instantiateInitialViewController() as! UINavigationController
//        let rootViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
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
        NetworkMonitorManager.shared.startMonitoring()
        print("End to monitor a current connection status")
    }


}

