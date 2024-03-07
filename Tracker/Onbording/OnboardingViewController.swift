//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 04.03.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(goToApp), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    init(image: UIImage, buttonText: String, labelText: String) {
        super.init(nibName: nil, bundle: nil)
        backgroundImage.image = image
        button.setTitle(buttonText, for: .normal)
        label.text = labelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}

extension OnboardingViewController {
    func setupAppearance() {
        view.addSubviews(backgroundImage, button, label)
        
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: view.bounds.height),
            backgroundImage.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant:  -view.bounds.height / 2 - 30)
        ])
    }
}

extension OnboardingViewController {
     @objc private func goToApp() {
         let tabBarViewController = TabBarViewController()
         tabBarViewController.modalPresentationStyle = .fullScreen
         present(tabBarViewController, animated: true)
    }
}
