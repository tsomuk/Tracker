//
//  ViewController.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 07/01/2024.
//

import UIKit

protocol ReloadCollectionProtocol: AnyObject {
    func reloadCollection()
}

final class TrackerViewController: UIViewController {
    
    // MARK: -  Properties & Constants
    
    private let trackerRepo = TrackerRepo.shared
    
    private var completedTrackers: [TrackerRecord] = []
    
    private let labelEmptyHolder = TrackerTextLabel(text: "Что будем отслеживать?", fontSize: 12, fontWeight: .medium)
    private let labelFilterHolder = TrackerTextLabel(text: "Ничего не найдено", fontSize: 12, fontWeight: .medium)
    
    // Data picker
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    let currentDate = Calendar.current
    
    // UICollection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        return collectionView
    }()
    
    // Vertical Stack with holder image and lable for the empty app
    private lazy var stackViewEmptyHolder: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageEmpty, labelEmptyHolder])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var imageEmpty: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "trackerHolder")
        return image
    }()
    
    // Vertical Stack with holder image and lable for filtered case
    private lazy var stackViewFilteredHolder: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageFiltered, labelFilterHolder])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var imageFiltered: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "filteredHolder")
        return image
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupAppearance()
        mainScreenContent(Date())
    }
    
    // MARK: - Private methods
    
    private func mainScreenContent(_ date: Date) {
        showTrackersInDate(date)
        reloadHolders()
    }
    
    private func setupNavBar() {
        // Plus Button
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = plusButton
        
        // Search Controller
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
        // Data picker
        view.addSubview(datePicker)
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
    }
    
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
        view.addSubviewsinView(collectionView, stackViewEmptyHolder, stackViewFilteredHolder)
        
        NSLayoutConstraint.activate([
            stackViewEmptyHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewEmptyHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackViewEmptyHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageEmpty.heightAnchor.constraint(equalToConstant: 80),
            imageEmpty.widthAnchor.constraint(equalToConstant: 80),
            
            stackViewFilteredHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewFilteredHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackViewFilteredHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageFiltered.heightAnchor.constraint(equalToConstant: 80),
            imageFiltered.widthAnchor.constraint(equalToConstant: 80),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func reloadHolders() {
        
        let allTrackersEmpty = trackerRepo.checkIsTrackerRepoEmpty()
        let visibleTrackersEmpty = trackerRepo.checkIsVisibleEmpty()
        
        if allTrackersEmpty {
            collectionView.isHidden = true
            stackViewEmptyHolder.isHidden = false
            stackViewFilteredHolder.isHidden = true
        }
        if !allTrackersEmpty && visibleTrackersEmpty {
            collectionView.isHidden = true
            stackViewEmptyHolder.isHidden = true
            stackViewFilteredHolder.isHidden = false
        } 
        if !allTrackersEmpty && !visibleTrackersEmpty {
            collectionView.isHidden = false
            stackViewEmptyHolder.isHidden = true
            stackViewFilteredHolder.isHidden = true
        }
    }
    
    @objc private func plusButtonTapped() {
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        let addNavController = UINavigationController(rootViewController: addNewTrackerViewController)
        present(addNavController, animated: true)
    }
    
    @objc private func pickerChanged() {
        mainScreenContent(datePicker.date)
    }
    
    private func showTrackersInDate(_ date: Date) {
        trackerRepo.removeAllVisibleCategory()
        let weekday = currentDate.component(.weekday, from: date)
        trackerRepo.appendTrackerInVisibleTrackers(weekday: weekday)
        collectionView.reloadData()
    }
    
    private func checkIsTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
}

// MARK: - Collection View extensions

extension TrackerViewController: UICollectionViewDataSource {
    
    // Numbers of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerRepo.getNumberOfCategories()
    }
    
    // Numbers of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerRepo.getNumberOfItemsInSection(section: section)
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCollectionHeader else { return UICollectionReusableView() }
        let title = trackerRepo.getTitleForSection(sectionNumber: indexPath.section)
        view.configureTitle(title)
        return view
    }
    
    // Configuration cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        let tracker = trackerRepo.getTrackerDetails(section: indexPath.section, item: indexPath.item)
        cell.delegate = self
        let isCompletedToday = checkIsTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.configureCell(tracker: tracker,
                           isCompletedToday: isCompletedToday, 
                           completedDays: completedDays,
                           indexPath: indexPath
        )
        
        if datePicker.date > Date() {
            cell.plusButton.isHidden = true
        }  else {
            cell.plusButton.isHidden = false
        }
        
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    // Size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCount : CGFloat = 2
        let space: CGFloat = 9
        let width : CGFloat = (collectionView.bounds.width - space - 32) / itemCount
        let height : CGFloat = 148
        return CGSize(width: width , height: height)
    }
    
    // Offsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    // Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerSize = CGSize(width: view.frame.width, height: 30)
        return headerSize
    }
}

extension TrackerViewController: ReloadCollectionProtocol {
    func reloadCollection() {
        mainScreenContent(datePicker.date)
    }
}

// MARK: - Delegates

extension TrackerViewController: TrackerDoneDelegate{
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
