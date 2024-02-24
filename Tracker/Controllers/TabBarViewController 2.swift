//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private let mainVC = TrackersViewController()
    private let statisticVC = StatisticViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainVC.title = "Трекеры"
        statisticVC.title = "Статистика"
        mainVC.tabBarItem.image = UIImage(systemName: "record.circle")
        statisticVC.tabBarItem.image = UIImage(systemName: "hare.fill")
        setViewControllers([mainVC, statisticVC], animated: true)
        
        
      
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
