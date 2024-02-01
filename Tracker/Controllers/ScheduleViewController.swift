//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func selectScheduleScreen(_ screen: ScheduleViewController, didSelectedDays schedule: [String])
}


class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var selectedDaysSwitches: [Bool] = [false, false, false, false, false, false, false]
    private var selectedDays : [String] = []
    
    private lazy var button: UIButton = {
        let button = TrackerBigButton(title: "Готово")
        button.addTarget(self, action: #selector(dismissFunc), for: .touchUpInside)
        return button
    }()
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        let tableCount : CGFloat = CGFloat(daysOfWeek.count)
        tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * tableCount).isActive = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    func setupAppearance() {
        view.backgroundColor = .ypWhite
        title = "Расписание"
        navigationItem.hidesBackButton = true
        view.addSubview(button)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    @objc func dismissFunc() {
        print("готово")
        delegate?.selectScheduleScreen(self, didSelectedDays: selectedDays)
        navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        selectedDaysSwitches[index] = sender.isOn
        switch index {
        case 0:
            selectedDays.append("Пн")
        case 1:
            selectedDays.append("Вт")
        case 2:
            selectedDays.append("Ср")
        case 3:
            selectedDays.append("Чт")
        case 4:
            selectedDays.append("Пт")
        case 5:
            selectedDays.append("Сб")
        case 6:
            selectedDays.append("Вск")
        default:
            print("Error")
        }
        
        
        print("🌻", selectedDays)
        
        
//        print("День \(daysOfWeek[index]) выбран: \(sender.isOn)")
    }
}
