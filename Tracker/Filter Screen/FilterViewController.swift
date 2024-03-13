//
//  FilterViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 08/03/2024.
//

import UIKit

struct FilterCell {
    let title: String
    let state: FilterCase
    let isSelected: Bool
}

enum FilterCase {
    case all
    case today
    case complete
    case uncomplete
}

protocol FilterDelegate {
    func setFilter(_ filterState: FilterCase)
}

class FilterViewController: UIViewController {
    
    // MARK: - Private varibles
    
    private let tableList: [FilterCase: String] = [.all: "allTrackers"~, .today: "todayTrackers"~, .complete: "doneTrackers"~, .uncomplete: "unDoneTrackers"~]
    
    var filterDelegate: FilterDelegate?
    
    var filterState: FilterCase = .all {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        title = "filterTitle"~
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
            let state: FilterCase = indexPath.row == 0 ? .all : (indexPath.row == 1 ? .today : (indexPath.row == 2 ? .complete : .uncomplete))
            self.filterDelegate?.setFilter(state)
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
        cell.textLabel?.text = Array(tableList)[indexPath.row].value
        cell.selectionStyle = .none
        cell.accessoryType = Array(tableList)[indexPath.row].key == filterState ? .checkmark : .none
        cell.backgroundColor = .ypBackground
        return cell
    }
}
