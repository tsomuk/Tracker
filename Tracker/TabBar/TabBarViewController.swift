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
        
        trackerViewController.title = "Трекеры"
        statisticViewController.title = "Статистика"
        
        trackerViewController.tabBarItem.image = UIImage(systemName: "record.circle")
        statisticViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
        
        let trackerNC = UINavigationController(rootViewController: trackerViewController)
        trackerNC.navigationBar.prefersLargeTitles = true
        let statisticNC = UINavigationController(rootViewController: statisticViewController)
        statisticNC.navigationBar.prefersLargeTitles = true
        
        setViewControllers([trackerNC, statisticNC], animated: true)
    }
    
}
