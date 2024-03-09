//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let statisticData : [String] = ["22"]
    
    let label1 = CustomStatisticView(title: "34", subtitle: "Лучший период")
    let label2 = CustomStatisticView(title: "2", subtitle: "Идеальные дни")
    let label3 = CustomStatisticView(title: "6", subtitle: "Трекеров завершено")
    let label4 = CustomStatisticView(title: "3", subtitle: "Среднее значение")
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label1,label2,label3,label4])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        mainScreenContent()
    }
    
    private func mainScreenContent() {
        if statisticData.isEmpty {
            addHolderView()
        } else {
            addStatisticView()
        }
    }
    
    private func addStatisticView() {
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "statHolder")
        return image
    }()
    
    private let label = TrackerTextLabel(text: "Анализировать пока нечего", fontSize: 12, fontWeight: .medium)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image,label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private func addHolderView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
