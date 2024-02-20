//
//  AddNewTrackerViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 15/01/2024.
//

import UIKit

protocol DismissProtocol: AnyObject {
    func dismissView()
}

final class AddNewTrackerViewController: UIViewController {
    
    var delegate: reloadCollectionProtocol?
    
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
    
    @objc func makeNewHabit(sender: UIButton) {
        sender.showAnimation {
            let newHabitViewController = NewHabitViewController()
            newHabitViewController.delegate = self
            let navController = UINavigationController(rootViewController: newHabitViewController)
            self.present(navController, animated: true)
        }
    }
    
    @objc func makeNewEvent(sender: UIButton) {
        sender.showAnimation {
            let newEventViewController = NewEventViewController()
            newEventViewController.delegate = self
            let navController = UINavigationController(rootViewController: newEventViewController)
            self.present(navController, animated: true)
        }
    }
}

extension AddNewTrackerViewController: DismissProtocol {
    func dismissView() {
        dismiss(animated: true) {
            self.delegate?.reloadCollection()
        }
    }
}
