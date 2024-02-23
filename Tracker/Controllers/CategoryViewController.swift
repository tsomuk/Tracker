//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryScreen(_ screen: CategoryViewController, didSelectedCategory category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    var trackerRepo = TrackerRepo.shared
    weak var delegate: CategoryViewControllerDelegate?
    
    private let label = TrackerTextLabel(text: "Привычки и события можно \nобъединить по смыслу", fontSize: 12, fontWeight: .medium)
    
    private lazy var button: UIButton = {
        let button = TrackerBigButton(title: "Добавить новую категорию")
        button.addTarget(self, action: #selector(goToAddNewCategory), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "trackerHolder")
        return image
    }()
    
    private lazy var holderStackView = {
        let stackView = UIStackView(arrangedSubviews: [image,label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        mainScreenContent()
    }
    
    private func mainScreenContent() {
        if trackerRepo.checkIsCategoryEmpty() {
            tableView.isHidden = true
            holderStackView.isHidden = false
        } else {
            tableView.isHidden = false
            holderStackView.isHidden = true
        }
    }
    
    private func setupAppearance() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        view.addSubview(button)
        view.addSubview(holderStackView)
        view.addSubview(tableView)
        let numbersOfRows = trackerRepo.getNumberOfCategories()
        
        NSLayoutConstraint.activate([
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * numbersOfRows)),
            
            holderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            holderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            holderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
//    private func addTableView() {
//        
//        
//        NSLayoutConstraint.activate([
//            
//        ])
//    }
//    
//    private func addHolderView() {
//        
//        
//        NSLayoutConstraint.activate([
//            
//            
//        ])
//    }
    
    @objc private func goToAddNewCategory(_ sender: UIButton) {
        sender.showAnimation {
            let addNewCategory = AddNewCategoryViewController()
            self.navigationController?.pushViewController(addNewCategory, animated: true)
        }   
    }
}

extension CategoryViewController: UITableViewDelegate {
    
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerRepo.getNumberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = trackerRepo.categoriesList[indexPath.row].title.rawValue
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.categoryScreen(self, didSelectedCategory: trackerRepo.categoriesList[indexPath.row])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
