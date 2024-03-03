//
//  TrackerRepo.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 27/01/2024.
//

import UIKit

enum CategoryList: String {
    case usefull = "Полезные привычки"
}

final class TrackerRepo {
    
    static let shared = TrackerRepo()
    private init() {}
    
    var visibleCategory: [TrackerCategory] = []
    
    var categories : [TrackerCategory] = [TrackerCategory(title: .usefull, trackers: [])]
    
    func appendTrackerInVisibleTrackers(weekday: Int) {
              
        var trackers = [Tracker]()
        
        for tracker in categories.first!.trackers {
            for day in tracker.schedule {
                if day == weekday {
                    trackers.append(tracker)
                }
            }
        }
        
        let category = TrackerCategory(title: .usefull, trackers: trackers)
        visibleCategory.append(category)
    }
    
    func removeAllVisibleCategory() {
        visibleCategory.removeAll()
    }
    
    func createNewTracker(tracker: Tracker) {
        var trackers: [Tracker] = []
        guard let list = categories.first else {return}
        for tracker in list.trackers{
            trackers.append(tracker)
        }
        trackers.append(tracker)
        categories = [TrackerCategory(title: .usefull, trackers: trackers)]
    }
    
    func createNewCategory(newCategoty: TrackerCategory) {
        categories.append(newCategoty)
    }
    
    func checkIsCategoryEmpty() -> Bool {
        categories.isEmpty
    }
    
    func checkIsTrackerRepoEmpty() -> Bool {
        categories[0].trackers.isEmpty
    }
    
    func checkIsVisibleEmpty() -> Bool {
        if visibleCategory.isEmpty {
            return true
        }
        return visibleCategory[0].trackers.isEmpty
    }
    
    func getTrackerDetails(section: Int, item: Int) -> Tracker {
        visibleCategory[section].trackers[item]
    }
    
    func getNumberOfCategories() -> Int {
        visibleCategory.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        visibleCategory[section].trackers.count
    }
    
    func getTitleForSection(sectionNumber: Int) -> String {
        visibleCategory[sectionNumber].title.rawValue
    }
}
