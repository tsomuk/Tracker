//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 18/01/2024.
//

import UIKit

class AddNewCategoryViewController: UIViewController {

    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
       

    
    private func configureUI() {
        view.backgroundColor = .ypWhite
        title = "Новая категория"
        navigationItem.hidesBackButton = true
        
        // Text Field
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypGray
        textField.placeholder = "Введите название трекера"
        textField.addPaddingToTextField()
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        button.addTarget(self, action: #selector(addNewCaterory), for: .touchUpInside)
        
    }

    @objc func addNewCaterory() {
        print("Add new category")
        navigationController?.popViewController(animated: true)
    }

}
