//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 16/01/2024.
//

import UIKit

class NewHabitViewController: UIViewController {

    let textField = UITextField()
    let cancelButton = UIButton()
    let createButton = UIButton()
    let tableList = ["Категория", "Расписание"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая привычка"
        configureUI()
        createtable()
    }
    

    func configureUI() {
        
        view.backgroundColor = .ypWhite
        
        // Text Field
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypGray
        textField.placeholder = "Введите название трекера"
        textField.addPaddingToTextField()
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Cancel Button
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        
        view.addSubview(cancelButton)
        
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
       
        
        // Create Button
        createButton.setTitle("Создать", for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.ypBlack, for: .normal)
        
        view.addSubview(createButton)
        
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        
    }
        
    @objc func cancel() {
        print("cancel")
        dismiss(animated: true)
        
    }
    @objc func create() {
        print("create")
    }
    
        
    func createtable() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        view.addSubview(tableView)
        
        tableView.rowHeight = 75
        tableView.backgroundColor = .ypBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)).isActive = true
        
    }
}


extension NewHabitViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tableList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    
}


