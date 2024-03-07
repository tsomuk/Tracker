//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryScreen(didSelectedCategory category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    var viewModel: CategoryViewModel?
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
        tableView.backgroundColor = .clear
        return tableView
    }()
   
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        mainScreenContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchCategory {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private methods
    
    private func mainScreenContent() {
            tableView.isHidden = false
        if let categoryNumber = viewModel?.categories.count {
            if categoryNumber > 0 {
                holderStackView.isHidden = true
            }
        } else { return }
    }
    
    private func setupAppearance() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        view.addSubview(button)
        view.addSubview(holderStackView)
        view.addSubview(tableView)

        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor),
            
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
    
    @objc private func goToAddNewCategory(_ sender: UIButton) {
        sender.showAnimation {
            let addNewCategory = AddNewCategoryViewController()
            self.navigationController?.pushViewController(addNewCategory, animated: true)
        }   
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainScreenContent()
        return viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel?.categories[indexPath.row].title ?? ""
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        viewModel?.didSelectModelAtIndex(indexPath) {
            self.dismiss(animated: true)
        }
    }
}
