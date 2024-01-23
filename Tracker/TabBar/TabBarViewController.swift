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
        
        let trackerVC = TrackerViewController()
        let statisticVC = StatisticViewController()
        
        trackerVC.title = "Трекеры"
        statisticVC.title = "Статистика"
        
        trackerVC.tabBarItem.image = UIImage(systemName: "record.circle")
        statisticVC.tabBarItem.image = UIImage(systemName: "hare.fill")
        
        let trackerNC = UINavigationController(rootViewController: trackerVC)
        trackerNC.navigationBar.prefersLargeTitles = true
        let statisticNC = UINavigationController(rootViewController: statisticVC)
        statisticNC.navigationBar.prefersLargeTitles = true
        
        setViewControllers([trackerNC, statisticNC], animated: true)
    }
    
}
