//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 16/01/2024.
//

import UIKit

protocol CreateTrackerProtocol: AnyObject {
    func createTrackerOrEvent(_ tracker: Tracker, _ category: String, isEdit: Bool)
}

final class NewTrackerViewController: UIViewController {
    
    // MARK: -  Properties & Constants
    
    private var enteredTrackerName = ""
    weak var delegate: DismissProtocol?
    weak var createDelegate: CreateTrackerProtocol?
    
    private let tableList = ["Категория", "Расписание"]
    private var selectedCategory: TrackerCategory?
    private var selectedSchedule: [Int] = []
    private var selectedColor: (color: UIColor?, item: IndexPath?)
    private var selectedEmoji: (emoji: String?, item: IndexPath?)
    
    // Parameters for the CollectionView
    let itemsInRow: CGFloat = 6
    let space: CGFloat = 5
    let outerMargin: CGFloat = 18
    
    private let emojiList = ["🙂","😻","🌺","🐶","❤️","😱"
                            ,"😇","😡","🥶","🤔","🍺","🍔",
                             "🥦","🏓","🥇","🎸","🏝","😪"]
    
    private let colorList: [UIColor] = [
        .ypColor1, .ypColor2, .ypColor3, .ypColor4, .ypColor5,.ypColor6,
        .ypColor7, .ypColor8, .ypColor9, .ypColor10, .ypColor11, .ypColor12,
        .ypColor13, .ypColor14, .ypColor15, .ypColor16, .ypColor17, .ypColor18]
    
    private let textField = TrackerTextField(placeHolder: "Введите название трекера")
    
    private lazy var limitLabel: UILabel = {
        let limitLabel = TrackerTextLabel(text: "Ограничение 38 символов", fontSize: 17, fontWeight: .regular)
        limitLabel.textColor = .ypRed
        limitLabel.isHidden = true
        return limitLabel
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textField, limitLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = TrackerSmallButton(title: "Отменить", backgroundColor: .clear)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = TrackerSmallButton(title: "Создать", backgroundColor: .ypGray)
        createButton.isEnabled = false
        createButton.setTitleColor(.ypBlack, for: .normal)
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        return createButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // UICollection View
    private lazy var emojiColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(EmojiColorCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: -  LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        textField.delegate = self
    }
    
    // MARK: -  Private methods
    
    func setupAppearance() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        view.addSubviews(textFieldStack, tableView, emojiColorCollectionView, stackView)
        
        NSLayoutConstraint.activate([
            textFieldStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)),
            
            emojiColorCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiColorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            emojiColorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            emojiColorCollectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func checkCreateButtonValidation() {
        if selectedCategory != nil &&
            selectedColor.color != nil &&
            selectedSchedule.count > 0 &&
            selectedEmoji.emoji != nil &&
            enteredTrackerName.count > 0 &&
            enteredTrackerName.count <= 38
        {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
            createButton.setTitleColor(.ypWhite, for: .normal)
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
            createButton.setTitleColor(.ypBlack, for: .normal)
        }
    }
    
    @objc private func cancel(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
    var isEdit = false
    
    var tracker: Tracker? = nil
    
    @objc private func create(_ sender: UIButton) {
        let newTracker = Tracker(id: isEdit ? tracker!.id : UUID(),
                                 title: enteredTrackerName,
                                 color: selectedColor.color ?? .cyan,
                                 emoji: selectedEmoji.emoji ?? "⚠️",
                                 schedule: selectedSchedule,
                                 trackerCategory: selectedCategory?.title ?? "")
        
        dismiss(animated: true)
        self.delegate?.dismissView()
        self.createDelegate?.createTrackerOrEvent(newTracker, selectedCategory?.title ?? "", isEdit: isEdit)
    }
    
    func setTrackerData(tracker: Tracker) {
        isEdit = true
        self.tracker = tracker
        textField.text = tracker.title
        selectedCategory = TrackerCategory(title: tracker.trackerCategory, trackers: [])
        selectedSchedule = tracker.schedule
        if let index = emojiList.firstIndex(where: {$0 == tracker.emoji}) {
            selectedEmoji = (emoji: tracker.emoji, item: IndexPath(item: index, section: 0))
        }
        
        if let index = colorList.firstIndex(where: {$0 == tracker.color}) {
            selectedColor = (color: tracker.color, item: IndexPath(item: index, section: 1))
        }
        
        checkCreateButtonValidation()
        tableView.reloadData()
        emojiColorCollectionView.reloadData()
    }
}

// MARK: -  UITableView Extension

extension NewTrackerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        let item = "\(tableList[indexPath.row])"
        cell.textLabel?.text = item
        if item == "Категория" {
            cell.detailTextLabel?.text = selectedCategory?.title
            cell.detailTextLabel?.textColor = .ypGray
        }
        if item == "Расписание" {
            var text : [String] = []
            for day in selectedSchedule {
                text.append(day.getShortDay())
            }
            cell.detailTextLabel?.text = text.joined(separator: ", ")
            cell.detailTextLabel?.textColor = .ypGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Снимаем выделение ячейки
        
        let selectedItem = tableList[indexPath.row]
        
        if selectedItem == "Категория" {
            let categoryViewModel = CategoryViewModel()
            let categoryViewController = CategoryViewController()
            categoryViewController.viewModel = categoryViewModel
            categoryViewModel.delegate = self
            let navigatonVC = UINavigationController(rootViewController: categoryViewController)
            present(navigatonVC, animated: true)
        }
        
        if selectedItem == "Расписание" {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}

// MARK: -  UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        enteredTrackerName = text
        checkCreateButtonValidation()
        if text.count >= 38 {
            limitLabel.isHidden = false
            return false
        } else {
            limitLabel.isHidden = true
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        return text.count > 38 ? false : true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
    }
}

// MARK: -  CategoryViewControllerDelegate & SelectedScheduleDelegate

extension NewTrackerViewController: CategoryViewControllerDelegate {
    func categoryScreen(didSelectedCategory category: TrackerCategory) {
        selectedCategory = category
        checkCreateButtonValidation()
        tableView.reloadData()
    }
}

extension NewTrackerViewController: SelectedScheduleDelegate {
    func selectScheduleScreen(_ screen: ScheduleViewController, didSelectedDays schedule: [Int]) {
        selectedSchedule = schedule
        checkCreateButtonValidation()
        tableView.reloadData()
    }
}

// MARK: -  UICollectionView Extension

extension NewTrackerViewController: UICollectionViewDataSource {
    
    // Numbers of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    // Numbers of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorList.count
    }
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? EmojiColorCollectionHeader else { return UICollectionReusableView() }
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            view.configureTitle("Emoji")
        case 1:
            view.configureTitle("Цвет")
        default:
            assertionFailure("Invalid section number")
        }
        return view
    }
    
    // Configuration cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiColorCollectionViewCell else { return UICollectionViewCell() }
        
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            cell.configureCell(emoji: emojiList[indexPath.item], color: UIColor.clear)
        case 1:
            cell.configureCell(emoji: "", color: colorList[indexPath.item])
        default:
            assertionFailure("Invalid section number")
        }
        return cell
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    // Size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.bounds.width - space * (itemsInRow - 1) - outerMargin * 2) / itemsInRow
        let height : CGFloat = width
        return CGSize(width: width , height: height)
    }
    
    // Offsets
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 23, left: outerMargin, bottom: 23, right: outerMargin)
    }
    
    // Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerSize = CGSize(width: view.frame.width, height: 30)
        return headerSize
    }
}

extension NewTrackerViewController: UICollectionViewDelegate {
    
    //SELECT Items
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            // Remove previous selection if exists
            if selectedEmoji.item != nil {
                let prevItem = selectedEmoji.item!
                let prevCell = collectionView.cellForItem(at: prevItem)
                prevCell?.backgroundColor = .clear
            }
            // New selection
            cell.configSelectedEmojiCell()
            selectedEmoji.emoji = emojiList[indexPath.item]
            selectedEmoji.item = indexPath
        case 1:
            // Remove previous selection if exists
            if selectedColor.item != nil {
                let prevItem = selectedColor.item!
                let prevCell = collectionView.cellForItem(at: prevItem)
                prevCell?.layer.borderWidth = 0
            }
            // New selection
            cell.configSelectedColorCell(with: colorList[indexPath.item])
            selectedColor.color = colorList[indexPath.item]
            selectedColor.item = indexPath
        default:
            assertionFailure("Invalid section number")
        }
        checkCreateButtonValidation()
    }
}
