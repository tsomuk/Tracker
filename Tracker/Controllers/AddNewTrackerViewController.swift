//
//  AddNewTrackerViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 15/01/2024.
//

import UIKit

class AddNewTrackerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создание трекера"
        addButton()
        view.backgroundColor = .ypWhite
    }
    
    
    func addButton(buttonTitle: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        
        view.addSubview(button)
        
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func addButton() {
        let newHabitButton = addButton(buttonTitle: "Привычка", action: #selector(makeNewHabit))
        newHabitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let newEventButton = addButton(buttonTitle: "Нерегулярное событие", action: #selector(makeNewEvent))
        newEventButton.topAnchor.constraint(equalTo: newHabitButton.bottomAnchor, constant: 16).isActive = true
    }
    
    
    @objc func makeNewHabit() {
            print("Новая привычка")
            let newTrackerVC = NewHabitViewController()
            let navController = UINavigationController(rootViewController: newTrackerVC)
            navController.modalPresentationStyle = .popover
            present(navController, animated: true, completion: nil)
        }
    
    @objc func makeNewEvent() {
            print("Новое нерегуляроное событие")
            let newTrackerVC = NewEventViewController()
            let navController = UINavigationController(rootViewController: newTrackerVC)
            navController.modalPresentationStyle = .popover
            present(navController, animated: true, completion: nil)
        }
    
    
    }
    
    
    


