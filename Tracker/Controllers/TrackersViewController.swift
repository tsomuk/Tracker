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
        
        let dataLabel = UILabel()
                   
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.backgroundColor = .systemRed
        dataLabel.text = "16.01.24"
        dataLabel.textColor = .black
        dataLabel.layer.cornerRadius = 8
        dataLabel.layer.masksToBounds = true
        dataLabel.textAlignment = .center
        dataLabel.font = .systemFont(ofSize: 17, weight: .regular)
        dataLabel.backgroundColor = .ypGray
        view.addSubview(dataLabel)
        NSLayoutConstraint.activate([
            dataLabel.heightAnchor.constraint(equalToConstant: 34),
            dataLabel.widthAnchor.constraint(equalToConstant: 77),
            dataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -130),
            dataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
                
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
               
               
               stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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

