//
//  TrackerBigButton.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 25/01/2024.
//

import UIKit

final class TrackerBigButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = .ypBlack
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.setTitleColor(.ypWhite, for: .normal)
//        self.addTarget(self, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


