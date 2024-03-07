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
    
    private lazy var createCategoryButton: UIButton = {
        let button = TrackerBigButton(title: "Готово")
        button.addTarget(self, action: #selector(addNewCaterory), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var enteredCategoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        textField.delegate = self
        checkCreateCategoryButtonValidation()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
        
        title = "Новая категория"
        navigationItem.hidesBackButton = true
        
        view.addSubview(createCategoryButton)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func addNewCaterory(_ sender: UIButton) {
        sender.showAnimation { [self] in
            trackerCategoryStore.createCategory(TrackerCategory(title: enteredCategoryName, trackers: []))
        navigationController?.popViewController(animated: true)
        }
    }
    
    func checkCreateCategoryButtonValidation() {
        if
            enteredCategoryName.count > 0
        {
            createCategoryButton.isEnabled = true
            createCategoryButton.backgroundColor = .ypBlack
            createCategoryButton.setTitleColor(.ypWhite, for: .normal)
        } else {
            createCategoryButton.isEnabled = false
            createCategoryButton.backgroundColor = .ypGray
            createCategoryButton.setTitleColor(.ypBlack, for: .normal)
        }
    }
    
}

// MARK: -  UITextFieldDelegate

extension AddNewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enteredCategoryName = textField.text ?? ""
        checkCreateCategoryButtonValidation()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enteredCategoryName = textField.text!
        textField.resignFirstResponder()
        checkCreateCategoryButtonValidation()
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
