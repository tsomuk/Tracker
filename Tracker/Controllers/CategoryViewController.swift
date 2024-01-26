//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

class CategoryViewController: UIViewController {
    
    
    private let label = TrackerTextLabel(text: "Привычки и события можно \nобъединить по смыслу", fontSize: 12, fontWeight: .medium)
    
    private let button = TrackerBigButton(title: "Добавить категорию")



    private lazy var image: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "trackerHolder")
    return image
    }()

    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    func setupAppearance() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        view.addSubview(stackView)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc func goToAddNewCategory() {
        print("add new caterory")
        let addNewCategory = AddNewCategoryViewController()
        navigationController?.pushViewController(addNewCategory, animated: true)
    }
}
