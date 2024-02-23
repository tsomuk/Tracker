//
//  NewEventViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 16/01/2024.
//

import UIKit

final class NewEventViewController: UIViewController {
    
    weak var delegate: DismissProtocol?
    
    private let tableList = ["Категория"]
    private let emojiList = ["🙂","😻","🌺","🐶","❤️","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    private let colorList: [UIColor] = [.ypColor1,.ypColor2,.ypColor3,.ypColor4,.ypColor5,.ypColor6,.ypColor7,.ypColor8,.ypColor9,.ypColor10,.ypColor11,.ypColor12,.ypColor13,.ypColor14,.ypColor15,.ypColor16,.ypColor17,.ypColor18]
    
    private var enteredTrackerName: String?
    private var selectedCategory : TrackerCategory?
    let trackerRepo = TrackerRepo.shared
    
    private let textField = TrackerTextField(placeHolder: "Введите название трекера")
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.isEnabled = false
        createButton.backgroundColor = .ypGray
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.ypBlack, for: .normal)
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        return createButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        textField.delegate = self
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func setupAppearance() {
        view.backgroundColor = .ypWhite
        title = "Новое нерегулярное событие"
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        view.addSubview(textField)
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)),
        ])
    }
    
    func checkCreateButtonValidation() {
        if selectedCategory != nil && enteredTrackerName != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
            createButton.setTitleColor(.ypWhite, for: .normal)
        }
    }
    
    @objc private func cancel(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func create(_ sender: UIButton) {
        sender.showAnimation {
            let newTracker = Tracker(id: UUID(),
                                     title: self.enteredTrackerName ?? "",
                                     color: .ypColor5,
                                     emoji: "☠️",
                                     schedule: [Weekday.monday, Weekday.tuesday, Weekday.wednesday, Weekday.thursday, Weekday.friday, Weekday.saturday, Weekday.sunday])
            
            self.trackerRepo.createNewTracker(tracker: newTracker)
            self.dismiss(animated: true)
            self.delegate?.dismissView()
        }
    }
}

extension NewEventViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = tableList[indexPath.row]
        cell.detailTextLabel?.text = selectedCategory?.title.rawValue
        cell.detailTextLabel?.textColor = .ypGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = tableList[indexPath.row]
        if selectedItem == "Категория" {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            let navigatonVC = UINavigationController(rootViewController: categoryViewController)
            present(navigatonVC, animated: true)
        }
    }
}

extension NewEventViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        enteredTrackerName = textField.text
        checkCreateButtonValidation()
        return true
    }
}

extension NewEventViewController: CategoryViewControllerDelegate {
    func categoryScreen(_ screen: CategoryViewController, didSelectedCategory category: TrackerCategory) {
        selectedCategory = category
        tableView.reloadData()
        checkCreateButtonValidation()
    }
}
