//
//  TrackerTable.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 30/01/2024.
//

import UIKit

final class TrackerTable: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.layer.cornerRadius = 16
        self.rowHeight = 75
        self.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .ypBackground
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
