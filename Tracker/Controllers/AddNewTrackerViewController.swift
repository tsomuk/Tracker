//
//  AddNewTrackerViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 15/01/2024.
//

import UIKit

final class AddNewTrackerViewController: UIViewController {

    private lazy var newHabitButton: UIButton = {
        let newHabitButton = TrackerBigButton(title: "Привычка")
        newHabitButton.addTarget(self, action: #selector(makeNewHabit), for: .touchUpInside)
        return newHabitButton
    }()
    
    private lazy var newEventButton: UIButton = {
        let newEventButton = TrackerBigButton(title: "Нерегулярное событие")
        newEventButton.addTarget(self, action: #selector(makeNewEvent), for: .touchUpInside)
        return newEventButton
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [newHabitButton,newEventButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        title = "Создание трекера"
        view.backgroundColor = .ypWhite
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
      
    @objc func makeNewHabit() {
            let newTrackerVC = NewHabitViewController()
            let navController = UINavigationController(rootViewController: newTrackerVC)
            present(navController, animated: true)
        }
    
    @objc func makeNewEvent() {
            let newTrackerVC = NewEventViewController()
            let navController = UINavigationController(rootViewController: newTrackerVC)
            present(navController, animated: true)
        }
    }
