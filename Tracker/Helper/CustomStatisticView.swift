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
//        layer.cornerRadius = 15
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.magenta.cgColor
//        layer.addGradienBorder(colors: [.green, .red])
        addSubview(titleLabel)
        addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            subLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            self.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

//extension UIView {
//    func addGradientBorder(colors: [UIColor], width: CGFloat) {
//        let gradient = CAGradientLayer()
//        gradient.frame = bounds
//        gradient.colors = colors.map { $0.cgColor }
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        
//        let shape = CAShapeLayer()
//        shape.lineWidth = width
//        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
//        shape.strokeColor = UIColor.black.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        gradient.mask = shape
//        
//        layer.addSublayer(gradient)
//    }
//}


extension CALayer {
    func addGradienBorder(colors: [UIColor], width: CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPointZero, size: self.bounds.size)
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake (1.0, 0.5)
        gradientLayer.colors = colors.map ({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.addSublayer(gradientLayer)
    }
}
