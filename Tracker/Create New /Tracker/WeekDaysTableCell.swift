//
//  WeekDaysSelectCell.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 15/02/2024.
//

import UIKit

protocol WeekDaySender: AnyObject {
    func weekDayAppend(_ weekDay: Int)
    func weekDayRemove(_ weekDay: Int)
}

final class WeekDaysTableCell: UITableViewCell {
    
    var weekDay: Int?
    weak var delegate: WeekDaySender?
    
    private lazy var weekDaytitle: UILabel = {
        let weekDaytitle = UILabel()
        weekDaytitle.translatesAutoresizingMaskIntoConstraints = false
        return weekDaytitle
    }()
    
    private lazy var onOffSwitch: UISwitch = {
        let onOffSwitch = UISwitch()
        onOffSwitch.onTintColor = .ypBlue
        onOffSwitch.translatesAutoresizingMaskIntoConstraints = false
        onOffSwitch.addTarget(self, action: #selector(onOffAction), for: .valueChanged)
        return onOffSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ weekDayUI: String, _ weekDay: Int) {
        backgroundColor = .ypBackground
        weekDaytitle.text = weekDayUI
        self.weekDay = weekDay
    }
    
    @objc private func onOffAction(_ sender: UISwitch) {
        guard let weekDay = weekDay else { return }
        sender.isOn ? delegate?.weekDayAppend(weekDay) : delegate?.weekDayRemove(weekDay)
    }
    
    func setupAppearance() {
        contentView.addSubview(weekDaytitle)
        contentView.addSubview(onOffSwitch)
        NSLayoutConstraint.activate([
            
            weekDaytitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            weekDaytitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            onOffSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            onOffSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
