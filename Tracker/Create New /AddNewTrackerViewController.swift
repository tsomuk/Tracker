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
    
    weak var delegate: ReloadCollectionProtocol?
    weak var createDelegate: CreateTrackerProtocol?
    
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
    
    @objc private func makeNewHabit(sender: UIButton) {
        sender.showAnimation {
            let newTrackerViewController = NewTrackerViewController()
            newTrackerViewController.delegate = self
            newTrackerViewController.createDelegate = self.createDelegate
            let navController = UINavigationController(rootViewController: newTrackerViewController)
            self.present(navController, animated: true)
        }
    }
    
    @objc private func makeNewEvent(sender: UIButton) {
        sender.showAnimation {
            let newEventViewController = NewEventViewController()
            newEventViewController.delegate = self
            newEventViewController.createDelegate = self.createDelegate
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
