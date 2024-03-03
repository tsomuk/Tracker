//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 17/01/2024.
//

import UIKit

//enum Weekday: String {
//    case monday = "Пн"
//    case tuesday = "Вт"
//    case wednesday = "Ср"
//    case thursday = "Чт"
//    case friday = "Пт"
//    case saturday = "Cб"
//    case sunday = "Вск"
//}

protocol SelectedScheduleDelegate: AnyObject {
    func selectScheduleScreen(_ screen: ScheduleViewController, didSelectedDays schedule: [Int])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: SelectedScheduleDelegate?
    
    private let daysOfWeek : [Int] = [1,2,3,4,5,6,7]
    private let daysOfWeekUI = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    private var selectedDays : [Int] = []
    
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
        tableView.register(WeekDaysTableCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        let tableCount : CGFloat = CGFloat(daysOfWeekUI.count)
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
    
    @objc private func dismissFunc(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.selectScheduleScreen(self, didSelectedDays: self.selectedDays)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ScheduleViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeekUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeekDaysTableCell else {
            return UITableViewCell()
        }
        cell.configureCell(daysOfWeekUI[indexPath.row], daysOfWeek[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ScheduleViewController: WeekDaySender {
    func weekDayAppend(_ weekDay: Int) {
        selectedDays.append(weekDay)
    }
    
    func weekDayRemove(_ weekDay: Int) {
        if let index = selectedDays.firstIndex(of: weekDay) {
            selectedDays.remove(at: index)
        }
    }
}

