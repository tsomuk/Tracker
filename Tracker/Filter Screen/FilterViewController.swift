//
//  FilterViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 08/03/2024.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Private varibles
    
    private let tableList = ["allTrackers"~, "todayTrackers"~, "doneTrackers"~, "unDoneTrackers"~]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        
    }
    
    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    // MARK: - Private methods
    
    private func setupAppearance() {
        title = "Фильтры"
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(4 * 75))
            
        ])
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print(self.tableList[indexPath.row])
            self.dismiss(animated: true)
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tableList[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    
    
}
