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

final class TrackerViewController: UIViewController  {
    
    // MARK: -  Properties & Constants
    
    private let trackerStore = TrackerStore()
    private let analyticsService = AnalyticsService()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: [TrackerRecord] = []
    
    private let labelEmptyHolder = TrackerTextLabel(text: "trackersHolderLabel"~, fontSize: 12, fontWeight: .medium)
    private let labelFilterHolder = TrackerTextLabel(text: "trackersSearchLabel"~, fontSize: 12, fontWeight: .medium)
    
    let currentDate = Calendar.current
    
    var isSearch = false
    var filterState: FilterCase = .all
    
    var weekDay = 0
    var trackers = [Tracker]()
    var categories = [TrackerCategory]()
    var visibleCategories: [TrackerCategory] {
        var resultCategories = [TrackerCategory]()
        for category in categories {
            let categoryTrackers = category.trackers.compactMap { tracker -> Tracker? in
                Tracker(id: tracker.id, title: tracker.title, color: tracker.color, emoji: tracker.emoji, schedule: tracker.schedule, trackerCategory: tracker.trackerCategory)
            }
            var resultTrackers: [Tracker] = []
            for tracker in categoryTrackers {
                for day in tracker.schedule {
                    if day == weekDay {
                        resultTrackers.append(tracker)
                    }
                }
            }
            let resultCategory = TrackerCategory(title: category.title, trackers: resultTrackers)
            if resultCategory.title == "Закрепленные" {
                resultCategories.insert(resultCategory, at: 0)
            } else {
                resultCategories.append(resultCategory)
            }
        }
        return resultCategories.filter({!$0.trackers.isEmpty})
    }
    
    var tempCategories = [TrackerCategory]()
    
    
    // Data picker
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 110).isActive = true
        datePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
        return datePicker
    }()
    
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
    
    private lazy var filterButton: UIButton = {
        filterButton = TrackerSmallButton(title: "filterButton"~, backgroundColor: .ypBlue)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTap), for: .touchUpInside)
        
        return filterButton
    }()
    
    private lazy var imageFiltered: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "filteredHolder")
        return image
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupAppearance()
        mainScreenContent(Date())
        trackerCategoryStore.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        analyticsService.report(event: "close", params: ["screen": "Main"])
    }
    
    // MARK: - Private methods
    
    private func mainScreenContent(_ date: Date) {
        self.weekDay = currentDate.component(.weekday, from: date)
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
        searchController.searchBar.placeholder = "searchTextFieldPlaceholder"~
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        // Data picker
        view.addSubview(datePicker)
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
        view.addSubviews(collectionView, stackViewEmptyHolder, stackViewFilteredHolder, filterButton)
        
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.widthAnchor.constraint(equalToConstant: 115),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func reloadHolders() {
        
        let allTrackersEmpty = categories.filter({!$0.trackers.isEmpty}).count == 0
        let visibleTrackersEmpty = visibleCategories.filter({!$0.trackers.isEmpty}).count == 0
        
        stackViewEmptyHolder.isHidden = !allTrackersEmpty
        collectionView.isHidden = visibleTrackersEmpty
        filterButton.isHidden = visibleTrackersEmpty
        stackViewFilteredHolder.isHidden = allTrackersEmpty ? true : !visibleTrackersEmpty
    }
    
    @objc private func plusButtonTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        addNewTrackerViewController.createDelegate = self
        let addNavController = UINavigationController(rootViewController: addNewTrackerViewController)
        present(addNavController, animated: true)
    }
    
    @objc private func pickerChanged() {
        mainScreenContent(datePicker.date)
    }
    
    @objc private func filterButtonTap(_ sender: UIButton) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
        sender.showAnimation {
            let filterViewController = FilterViewController()
            filterViewController.filterState = self.filterState
            filterViewController.filterDelegate = self
            let filterNavController = UINavigationController(rootViewController: filterViewController)
            self.present(filterNavController, animated: true)
        }
        
    }
    
    private func showTrackersInDate(_ date: Date) {
        fetchCategory()
        fetchRecord()
        collectionView.reloadData()
    }
    
    private func checkIsTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
}

// MARK: - UISearchControllerDelegate

extension TrackerViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 3 else { return }
        isSearch = true
        
        var searchResult = [TrackerCategory]()
        
        for categoryIndex in 0..<self.visibleCategories.count {
            var trackers = [Tracker]()
            
            for trackerIndex in 0..<self.visibleCategories[categoryIndex].trackers.count {
                if self.visibleCategories[categoryIndex].trackers[trackerIndex].title.contains(searchText) {
                    if let index = searchResult.firstIndex(where: {$0.title == self.visibleCategories[categoryIndex].title}) {
                        
                        trackers.append(self.visibleCategories[categoryIndex].trackers[trackerIndex])
                        
                        for tracker in searchResult[index].trackers {
                            trackers.append(tracker)
                        }
                        
                        let newCategory = TrackerCategory(title: searchResult[index].title, trackers: trackers)
                        searchResult[index] = newCategory
                        
                    } else {
                        let newCategory = TrackerCategory(title: self.visibleCategories[categoryIndex].title, trackers: [self.visibleCategories[categoryIndex].trackers[trackerIndex]])
                        searchResult.append(newCategory)
                    }
                }
            }
        }
        self.tempCategories = searchResult
        collectionView.reloadData()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearch = false
        collectionView.reloadData()
    }
    
}

// MARK: - Filters

extension TrackerViewController: FilterDelegate {
    func setFilter(_ filterState: FilterCase) {
        self.filterState = filterState
        
        switch filterState {
        case .all:
            isSearch = false
        case .today:
            isSearch = false
            datePicker.date = Date()
        case .complete:
            isSearch = true
            
            var searchResult = [TrackerCategory]()
            for categoryIndex in 0..<self.visibleCategories.count {
                var trackers = [Tracker]()
                for trackerIndex in 0..<self.visibleCategories[categoryIndex].trackers.count {
                    if checkIsTrackerCompletedToday(id: self.visibleCategories[categoryIndex].trackers[trackerIndex].id) {
                        if let index = searchResult.firstIndex(where: {$0.title == self.visibleCategories[categoryIndex].title}) {
                            trackers.append(self.visibleCategories[categoryIndex].trackers[trackerIndex])
                            for tracker in searchResult[index].trackers {
                                trackers.append(tracker)
                            }
                            let newCategory = TrackerCategory(title: searchResult[index].title, trackers: trackers)
                            searchResult[index] = newCategory
                        } else {
                            let newCategory = TrackerCategory(title: self.visibleCategories[categoryIndex].title, trackers: [self.visibleCategories[categoryIndex].trackers[trackerIndex]])
                            searchResult.append(newCategory)
                        }
                    }
                }
            }
            self.tempCategories = searchResult
        case .uncomplete:
            isSearch = true
            var searchResult = [TrackerCategory]()
            for categoryIndex in 0..<self.visibleCategories.count {
                var trackers = [Tracker]()
                for trackerIndex in 0..<self.visibleCategories[categoryIndex].trackers.count {
                    if !checkIsTrackerCompletedToday(id: self.visibleCategories[categoryIndex].trackers[trackerIndex].id) {
                        if let index = searchResult.firstIndex(where: {$0.title == self.visibleCategories[categoryIndex].title}) {
                            trackers.append(self.visibleCategories[categoryIndex].trackers[trackerIndex])
                            for tracker in searchResult[index].trackers {
                                trackers.append(tracker)
                            }
                            let newCategory = TrackerCategory(title: searchResult[index].title, trackers: trackers)
                            searchResult[index] = newCategory
                        } else {
                            let newCategory = TrackerCategory(title: self.visibleCategories[categoryIndex].title, trackers: [self.visibleCategories[categoryIndex].trackers[trackerIndex]])
                            searchResult.append(newCategory)
                        }
                    }
                }
            }
            self.tempCategories = searchResult
        }
        reloadCollection()
    }
}

// MARK: - Collection View extensions

extension TrackerViewController: UICollectionViewDataSource {
    
    // Numbers of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isSearch ? tempCategories.count : visibleCategories.count
    }
    
    // Numbers of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isSearch ? tempCategories[section].trackers.count : visibleCategories[section].trackers.count
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCollectionHeader else { return UICollectionReusableView() }
        let title = isSearch ? tempCategories[indexPath.section].title : visibleCategories[indexPath.section].title
        view.configureTitle(title)
        return view
    }
    
    // Configuration cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        let tracker = isSearch ? tempCategories[indexPath.section].trackers[indexPath.item] : visibleCategories[indexPath.section].trackers[indexPath.item]
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
    
    // MARK: - Context Menu
    
    // Context menu for cell body only
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        let parameters = UIPreviewParameters()
            let previewView = UITargetedPreview(view: cell.bodyView, parameters: parameters)
        return previewView
    }
    
    // Context menu configuratiuon
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        let config = UIContextMenuConfiguration(actionProvider:  { _ in
            
            let pin = UIAction(title: "pin"~,
                               image: UIImage.init(systemName: "pin")) { _ in
                self.pinTracker(indexPath: indexPath)
            }
            
            let unpin = UIAction(title: "unpin"~,
                                 image: UIImage.init(systemName: "pin.slash")) { _ in
                self.pinTracker(indexPath: indexPath)
            }
            
            let edit = UIAction(title: "edit"~,
                                image: UIImage.init(systemName: "pencil")) { _ in
                self.editTracker(indexPath: indexPath)
            }
            
            let delete = UIAction(title: "delete"~,
                                  image: UIImage.init(systemName: "trash"),
                                  attributes: .destructive) { _ in
                self.deleteTracker(indexPath: indexPath)
            }
            
            if self.visibleCategories[indexPath.section].title == "Закрепленные" {
                return UIMenu(options: UIMenu.Options.displayInline, children: [unpin, edit, delete])
            } else {
                return UIMenu(options: UIMenu.Options.displayInline, children: [pin, edit, delete])
            }
        })
        return config
    }
    
    // Context menu logic
    private func pinTracker(indexPath: IndexPath) {
        if self.visibleCategories[indexPath.section].title == "Закрепленные" {
            trackerCategoryStore.deleteTrackerFromCategory(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row], with: "Закрепленные")
            trackerCategoryStore.addTrackerToCategory(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row], with: self.visibleCategories[indexPath.section].trackers[indexPath.row].trackerCategory)
        } else {
            if trackerCategoryStore.fetchAllCategories().filter({$0.title == "Закрепленные"}).count == 0 {
                let newCategory = TrackerCategory(title: "Закрепленные", trackers: [])
                trackerCategoryStore.createCategory(newCategory)
            }
            trackerCategoryStore.deleteTrackerFromCategory(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row], with: self.visibleCategories[indexPath.section].title)
            trackerCategoryStore.addTrackerToCategory(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row], with: "Закрепленные")
        }
        fetchCategory()
        collectionView.reloadData()
    }
    
    private func editTracker(indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
        let vc = NewTrackerViewController()
        vc.createDelegate = self
        vc.setTrackerData(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row])
        present(vc, animated: true)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
        let actionSheet = UIAlertController(title: "actionSheetTitle"~, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "deleteButton"~, style: .destructive) { _ in
            let trackerForDelete = self.visibleCategories[indexPath.section].trackers[indexPath.row]
            self.trackerStore.deleteTracker(tracker: trackerForDelete)
            self.trackerRecordStore.deleteAllRecordFor(tracker: trackerForDelete)
            self.fetchCategory()
            self.collectionView.reloadData()
            self.reloadHolders()
        }
        let cancelAction = UIAlertAction(title: "cancelButton"~, style: .cancel) { _ in
        }
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension TrackerViewController: ReloadCollectionProtocol {
    func reloadCollection() {
        mainScreenContent(datePicker.date)
    }
}

// MARK: - CreateTrackerProtocol

extension TrackerViewController: CreateTrackerProtocol {
    
    func createTrackerOrEvent(_ tracker: Tracker, _ category: String, isEdit: Bool) {
        if trackerCategoryStore.fetchAllCategories().filter({$0.title == category}).count == 0 {
            let newCategory = TrackerCategory(title: category, trackers: [])
            trackerCategoryStore.createCategory(newCategory)
        }
        if isEdit {
            trackerStore.deleteTracker(tracker: tracker)
        }
        createCategoryAndTracker(tracker: tracker, with: category)
        fetchCategory()
        collectionView.reloadData()
    }
}

// MARK: - CategoryStore

extension TrackerViewController {
    private func fetchCategory() {
        let coreDataCategories = trackerCategoryStore.fetchAllCategories()
        categories = coreDataCategories.compactMap { coreDataCategory in
            trackerCategoryStore.decodingCategory(from: coreDataCategory)
        }
        
        
        var trackers = [Tracker]()
        
        for visibleCategory in visibleCategories {
            for tracker in visibleCategory.trackers {
                let newTracker = Tracker(id: tracker.id, title: tracker.title, color: tracker.color, emoji: tracker.emoji, schedule: tracker.schedule, trackerCategory: visibleCategory.title)
                trackers.append(newTracker)
            }
        }
        
        self.trackers = trackers
    }
    
    private func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: titleCategory)
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate {
    func didUpdateData(in store: TrackerCategoryStore) {
        collectionView.reloadData()
    }
}

// MARK: - Delegates

extension TrackerViewController: TrackerDoneDelegate{
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        createRecord(record: trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        deleteRecord(record: trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - RecordStore

extension TrackerViewController {
    private func fetchRecord()  {
        completedTrackers = trackerRecordStore.fetchRecords()
        print(completedTrackers)
    }
    
    private func createRecord(record: TrackerRecord)  {
        trackerRecordStore.addNewRecord(from: record)
        fetchRecord()
    }
    
    private func deleteRecord(record: TrackerRecord)  {
        trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
        fetchRecord()
    }
}
