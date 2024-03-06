//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 06/03/2024.
//

import UIKit

final class ViewModel {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    let trackerCategoryStore = TrackerCategoryStore()
    
    var categories = [TrackerCategory]()
    
    func fetchCategory(callBack: @escaping () -> ()) {
        categories = trackerCategoryStore.fetchAllCategories().compactMap({ category in
            self.trackerCategoryStore.decodingCategory(from: category)
        })
        callBack()
    }
    
    func didSelectCell(_ tableView: UITableView, _ indexPath: IndexPath, _ callBack: @escaping () -> ()) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.categoryScreen(didSelectedCategory: TrackerCategory(title: categories[indexPath.row].title, trackers: []))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            callBack()
        }
    }
    
    func didDeselectCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
