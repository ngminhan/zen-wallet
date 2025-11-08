//
//  CustomTabBarController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    let centerDummy = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setValue(CustomTabBar(), forKey: "tabBar")
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(title: "Statistic", image: nil, tag: 1)
        
        centerDummy.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        
        let goalVC = GoalsViewController()
        goalVC.tabBarItem = UITabBarItem(title: "Goal", image: nil, tag: 3)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 4)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: statisticsVC),
            centerDummy,
            UINavigationController(rootViewController: goalVC),
            UINavigationController(rootViewController: profileVC)
        ]
        
        tabBar.tintColor = .greenSheen
        tabBar.backgroundColor = .white
        
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        }
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController !== centerDummy
    }
}
