//
//  CustomTabBarController.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 28/10/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        configureAppearance()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .home.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 22, height: 22)),
            tag: 0
        )
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .statistic.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 22, height: 22)),
            tag: 1
        )
        
        let journalVC = JournalViewController()
        journalVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .journal.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 22, height: 22)),
            tag: 2
        )
        
        let goalVC = GoalsViewController()
        goalVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .goal.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 22, height: 22)),
            tag: 3
        )
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .profile.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 22, height: 22)),
            tag: 4
        )
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: statisticsVC),
            UINavigationController(rootViewController: journalVC),
            UINavigationController(rootViewController: goalVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        let normal = appearance.stackedLayoutAppearance.normal
        normal.iconColor = .lightGray
        
        let selected = appearance.stackedLayoutAppearance.selected
        selected.iconColor = .greenSheen
        selected.titleTextAttributes = [.foregroundColor: UIColor.greenSheen]
        selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .greenSheen
        tabBar.unselectedItemTintColor = .lightGray
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {}
