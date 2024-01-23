//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    var selectedDays: [Bool] = [false, false, false, false, false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        title = "Расписание"
        navigationItem.hidesBackButton = true
        createtable()
        addButtom()
    }
    
    func addButtom() {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        
        button.addTarget(self, action: #selector(dismissFunc), for: .touchUpInside)
    }
    
    @objc func dismissFunc() {
        print("готово")
        navigationController?.popViewController(animated: true)
    }
    
    
    func createtable() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        let tableCount : CGFloat = CGFloat(daysOfWeek.count)
        tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * tableCount).isActive = true
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
        
        
        
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
        selectedDays[index] = sender.isOn
        print("День \(daysOfWeek[index]) выбран: \(sender.isOn)")
    }
}
