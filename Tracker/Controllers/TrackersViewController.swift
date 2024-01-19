//
//  ViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

class TrackersViewController: UIViewController {
    
    
    var categories: [TrackerCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        holderView()
        
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        
        // Plus Button
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = plusButton
        
        // Search Controller
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
        // Data picker
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
    }
    
    func holderView() {
        // Vertical Stack with holder image and lable
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
        
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    
    
    
    @objc func plusButtonTapped() {
        let addNewTrackerVC = AddNewTrackerViewController()
        let navController = UINavigationController(rootViewController: addNewTrackerVC)
        navController.modalPresentationStyle = .popover
        present(navController, animated: true, completion: nil)
    }
    
    
}

