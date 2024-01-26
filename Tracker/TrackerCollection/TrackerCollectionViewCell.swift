//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 21/01/2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    lazy var bodyView: UIView = {
        let bodyView = UIView()
        bodyView.layer.cornerRadius = 16
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }()
    
    lazy var emojiView: UIView = {
        let emojiView = UIView()
        emojiView.layer.cornerRadius = 12
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .white
        emojiView.alpha = 0.3
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        return emojiView
    }()
    
    lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 12, weight: .medium)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypBlack
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var dayCounter: UILabel = {
        let dayCounter = UILabel()
        dayCounter.font = .systemFont(ofSize: 12, weight: .medium)
        dayCounter.textColor = .ypBlack
        dayCounter.translatesAutoresizingMaskIntoConstraints = false
        return dayCounter
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.layer.cornerRadius = 17
        let buttonImage = UIImage(named: "plusButton")
        plusButton.setImage(buttonImage, for: .normal)
        return plusButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(_ text: String) {
        titleLabel.text = text
    }
    
    func configureEmojiLabel(_ text: String) {
        emojiLabel.text = text
    }
    
    func configureDayLabel(_ text: String) {
        dayCounter.text = text
    }
    
    func configurePrimaryColor(_ color: UIColor) {
        bodyView.backgroundColor = color
        plusButton.tintColor = color
    }
    
    func setupAppearance() {
        addSubview(bodyView)
        addSubview(emojiView)
        addSubview(emojiLabel)
        addSubview(titleLabel)
        addSubview(dayCounter)
        addSubview(plusButton)
        NSLayoutConstraint.activate([
            
            bodyView.heightAnchor.constraint(equalToConstant: 90),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -12),
            
            dayCounter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dayCounter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dayCounter.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 16),
            
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8)
        ])
    }
}
