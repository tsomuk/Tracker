//
//  EmojiColorCollectionViewCell.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 24/02/2024.
//

import UIKit

final class EmojiColorCollectionViewCell: UICollectionViewCell {
    
    
    lazy var emojiView: UILabel = {
        let emojiView = UILabel()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = 8
        emojiView.font = .systemFont(ofSize: 38)
        emojiView.layer.masksToBounds = true
        return emojiView
    }()
    
    lazy var colorView: UILabel = {
        let colorView = UILabel()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureCell(emoji: String, color: UIColor){
        emojiView.text = emoji
        colorView.backgroundColor = color
    }
    
    
    func setupAppearance() {
        addSubviewsInCell(emojiView,colorView)
        NSLayoutConstraint.activate([
            emojiView.heightAnchor.constraint(equalToConstant: 40),
            emojiView.widthAnchor.constraint(equalToConstant: 40),
            
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
