//
//  SceneDelegate.swift
//  zenwallet
//
//  Created by Nguyễn Minh An on 26/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: loginVC)
        window.rootViewController = nav
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func goToHome() {
        let home = HomeViewController()
        changeRootViewController(to: home)
    }
    
    private func changeRootViewController(to vc: UIViewController) {
        guard let window = window else { return }
        
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        
        UIView.transition(with: window,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
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

