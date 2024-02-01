//
//  TrackerRepo.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 27/01/2024.
//

import UIKit

enum CategoryList: String {
    case usefull = "Полезные привычки"
    case sport = "Спорт"
}

final class TrackerRepo {
    
    static let shared = TrackerRepo()
    
    private let daysList = ["5 дней", "3 дня", "7 дней"]
    
    

    
      var categoriesList = [TrackerCategory(title: .usefull, tracker: [
        Tracker(id: UUID(), title: "Выучить Swift", color: .ypColor3, emoji: "🧑🏻‍💻", schedule: nil, category: .usefull),
        Tracker(id: UUID(), title: "Отправить 10 резюме", color: .ypColor11, emoji: "💼", schedule: nil, category: .usefull),
        Tracker(id: UUID(), title: "Выпить пива", color: .ypColor18, emoji: "🍺", schedule: nil, category: .usefull)
    ]), TrackerCategory(title: .sport, tracker:[Tracker(id: UUID(), title: "Выпить пива", color: .ypColor18, emoji: "🍺", schedule: nil, category: .sport)])]
    
    var newTracker = Tracker(id: UUID(), title: "", color: .ypColor9, emoji: "☠️", schedule: nil)
    
    func createNewTracker(tracker: Tracker) {
      
    }
    
//         func createNewTracker(id: Int, title: String, color: UIColor, emoji: String, schedule: Tracker.Schedule) -> Tracker {
//            let newTracker = Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
//            trackerRepo.append(newTracker)
//            return newTracker
//        }
    
    
    //
    //     func createNewEvent(id: Int, title: String, color: UIColor, emoji: String) -> Tracker {
    //        let newEvent = Tracker(id: id, title: title, color: color, emoji: emoji, schedule: nil)
    //        trackerRepo.append(newEvent)
    //        return newEvent
    //    }
    
    
    func createNewCategory(newCategoty: TrackerCategory) {
        categoriesList.append(newCategoty)
    }
    
    func checkIsTrackerRepoEmpry() -> Bool {
        if categoriesList.isEmpty {
            return true
        } else {
            return false
        }
    }
    

    
    func getTrackerDetails(section: Int, item: Int) -> Tracker {
        categoriesList[section].tracker[item]
    }
    
    func getDaysCounter(section: Int = 1, item: Int) -> String {
        daysList[item]
    }
    
    func getNumberOfCategories() -> Int {
        categoriesList.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        categoriesList[section].tracker.count
    }
    
    func getTitleForSection(sectionNumber: Int) -> String {
        categoriesList[sectionNumber].title.rawValue
    }
}

