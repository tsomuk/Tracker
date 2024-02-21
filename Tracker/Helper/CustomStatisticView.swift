//
//  CustomStaticView.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 02/02/2024.
//


import UIKit

final class CustomStatisticView: UIView {
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subLabel.text = subtitle
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 34, weight: .bold)
        title.textColor = .ypBlack
        return title
    }()
    
    private lazy var subLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .bold)
        title.textColor = .ypBlack
        return title
    }()
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.magenta.cgColor
        addSubview(titleLabel)
        addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            subLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
        ])
    }
}
