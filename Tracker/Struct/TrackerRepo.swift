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
    
    var categories : [TrackerCategory] = [TrackerCategory(title: .usefull, tracker: [
//        Tracker(id: UUID(),
//                title: "Выучить Swift",
//                color: .ypColor2,
//                emoji: "🧑🏻‍💻",
//                schedule: [Weekday.monday, Weekday.thursday]
//               ),
//        Tracker(id: UUID(),
//                title: "Отправить 10 резюме",
//                color: .ypColor11,
//                emoji: "💼",
//                schedule: [Weekday.monday, Weekday.wednesday, Weekday.friday]),
//        Tracker(id: UUID(),
//                title: "Выпить пива",
//                color: .ypColor18,
//                emoji: "🍺",
//                schedule: [Weekday.monday, Weekday.thursday])
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
        
        for tracker in categories.first!.tracker {
            for day in tracker.schedule {
                if day == weekDayCase {
                    trackers.append(tracker)
                }
            }
        }
        
        let category = TrackerCategory(title: .usefull, tracker: trackers)
        visibleCategory.append(category)
    }
    
    func removeAllVisibleCategory() {
        visibleCategory.removeAll()
    }
    
    func createNewTracker(tracker: Tracker) {
        var trackers: [Tracker] = []
        guard let list = categories.first else {return}
        for tracker in list.tracker{
            trackers.append(tracker)
        }
        trackers.append(tracker)
        categories = [TrackerCategory(title: .usefull, tracker: trackers)]
    }
    
    func createNewCategory(newCategoty: TrackerCategory) {
        categories.append(newCategoty)
    }
    
    func checkIsCategoryEmpty() -> Bool {
        categories.isEmpty
    }
    
    func checkIsTrackerRepoEmpty() -> Bool {
        categories[0].tracker.isEmpty
    }
    
    func checkIsVisibleEmpty() -> Bool {
        if visibleCategory.isEmpty {
            return true
        }
        if visibleCategory[0].tracker.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getTrackerDetails(section: Int, item: Int) -> Tracker {
        visibleCategory[section].tracker[item]
    }
    
    func getNumberOfCategories() -> Int {
        visibleCategory.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        visibleCategory[section].tracker.count
    }
    
    func getTitleForSection(sectionNumber: Int) -> String {
        visibleCategory[sectionNumber].title.rawValue
    }
}
