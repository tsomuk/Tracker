//
//  TrackerTextField.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 26/01/2024.
//

import UIKit

final class TrackerTextField: UITextField {
    
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        self.backgroundColor = .ypBackground
        self.textColor = .ypGray
        self.placeholder = placeHolder
        self.addPaddingToTextField()
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}

