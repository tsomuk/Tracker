//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 18/01/2024.
//

import UIKit

class AddNewCategoryViewController: UIViewController {
    
    private var textField = TrackerTextField(placeHolder: "Введите название трекера")
    private var button = TrackerBigButton(title: "Готово")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
        
        title = "Новая категория"
        navigationItem.hidesBackButton = true
        
        view.addSubview(button)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc func addNewCaterory() {
        print("Add new category")
        navigationController?.popViewController(animated: true)
    }
}
