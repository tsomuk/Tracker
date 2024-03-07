//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 06/03/2024.
//

import Foundation

final class CategoryViewModel {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    let trackerCategoryStore = TrackerCategoryStore()
    
    var categories = [TrackerCategory]()
    
    func fetchCategory(callBack: @escaping () -> ()) {
        categories = trackerCategoryStore.fetchAllCategories().compactMap({ category in
            self.trackerCategoryStore.decodingCategory(from: category)
        })
        callBack()
    }
    
    func didSelectModelAtIndex(_ indexPath: IndexPath, _ callBack: @escaping () -> ()) {
        delegate?.categoryScreen(didSelectedCategory: TrackerCategory(title: categories[indexPath.row].title, trackers: []))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            callBack()
        }
    }
}
