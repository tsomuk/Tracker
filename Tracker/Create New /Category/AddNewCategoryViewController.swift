//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 18/01/2024.
//

import UIKit

final class AddNewCategoryViewController: UIViewController {
    
    private var textField = TrackerTextField(placeHolder: "Введите название трекера")
    let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var button: UIButton = {
        let button = TrackerBigButton(title: "Готово")
        button.addTarget(self, action: #selector(addNewCaterory), for: .touchUpInside)
        return button
    }()
    
    private var enteredCategoryName = "" {
        didSet {
            print(enteredCategoryName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        textField.delegate = self
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
    
    @objc private func addNewCaterory() {
        trackerCategoryStore.createCategory(TrackerCategory(title: enteredCategoryName, trackers: []))
        navigationController?.popViewController(animated: true)
    }
}




// MARK: -  UITextFieldDelegate

extension AddNewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        enteredCategoryName = text
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enteredCategoryName = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
    }
}
