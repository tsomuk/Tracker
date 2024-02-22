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

    var visibleCategoty: [TrackerCategory] = []
    
    var categoriesList = [TrackerCategory(title: .usefull, tracker: [
//                Tracker(id: UUID(), title: "Выучить Swift", color: .ypColor2, emoji: "🧑🏻‍💻", schedule: nil, category: .usefull),
//                Tracker(id: UUID(), title: "Отправить 10 резюме", color: .ypColor11, emoji: "💼", schedule: nil, category: .usefull),
//                Tracker(id: UUID(), title: "Выпить пива", color: .ypColor18, emoji: "🍺", schedule: nil, category: .usefull)
    ])]
    
    func appendTrackerInVisibleTrackers(weekday: Int) {
        var weekDayCase: Weekday = .monday
        
        switch weekday {
        case 1:
            weekDayCase = .sunday
        case 2:
            weekDayCase = .monday
        case 3:
            weekDayCase = .tuesday
        case 4:
            weekDayCase = .wednesday
        case 5:
            weekDayCase = .thursday
        case 6:
            weekDayCase = .friday
        case 7:
            weekDayCase = .saturday
        default:
            break
        }
        
        var trackers = [Tracker]()
        
        for tracker in categoriesList.first!.tracker {
            for day in tracker.schedule!.schedule! {
                if day == weekDayCase {
                    trackers.append(tracker)
                }
            }
        }
        
        let category = TrackerCategory(title: .usefull, tracker: trackers)
        visibleCategoty.append(category)
    }
    
    func removeAllVisibleCategory() {
        visibleCategoty.removeAll()
    }
    
    func createNewTracker(tracker: Tracker) {
        var trackers: [Tracker] = []
        guard let list = categoriesList.first else {return}
        for tracker in list.tracker{
            trackers.append(tracker)
        }
        trackers.append(tracker)
        categoriesList = [TrackerCategory(title: .usefull, tracker: trackers)]
    }
    
    func createNewCategory(newCategoty: TrackerCategory) {
        categoriesList.append(newCategoty)
    }
    
    func checkIsTrackerRepoEmpry() -> Bool {
        visibleCategoty.isEmpty
    }
    
    func checkIsCategoryRepoEmpty() -> Bool {
        visibleCategoty.isEmpty
    }
    
    func getTrackerDetails(section: Int, item: Int) -> Tracker {
        visibleCategoty[section].tracker[item]
    }
    
    func getNumberOfCategories() -> Int {
        visibleCategoty.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        visibleCategoty[section].tracker.count
    }
    
    func getTitleForSection(sectionNumber: Int) -> String {
        visibleCategoty[sectionNumber].title.rawValue
    }
}
