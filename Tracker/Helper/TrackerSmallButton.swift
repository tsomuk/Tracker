//
//  TrackerSmallButton.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 25/02/2024.
//

import UIKit

final class TrackerSmallButton: UIButton {
    
    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.setTitleColor(.ypWhite, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
