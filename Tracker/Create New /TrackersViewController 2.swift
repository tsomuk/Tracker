//
//  ViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

class TrackersViewController: UIViewController {
    
    
    var categories: [TrackerCategoryStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        
        // Plus Button
        let plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .ypBlack
        view.addSubview(plusButton)
        plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        
        plusButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        // Button functionality
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        // Vertical Stack with image and lable
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        view.addSubview(stackView)
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "trackerHolder")
        stackView.addArrangedSubview(image)
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        stackView.addArrangedSubview(label)
        
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    

    @objc func plusButtonTapped() {
        print("PlusButtonTapped")
    }
    
}

