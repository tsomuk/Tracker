//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    private func configureTabs() {
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.title = "trakerTitle"~
        statisticViewController.title = "statisticTitle"~
        
        trackerViewController.tabBarItem.image = UIImage(systemName: "record.circle")
        statisticViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticNavigationController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([trackerNavigationController, statisticNavigationController], animated: true)
    }
}
