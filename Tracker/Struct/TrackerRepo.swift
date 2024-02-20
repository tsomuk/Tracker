//
//  TrackerRepo.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 27/01/2024.
//

import UIKit

enum CategoryList: String {
    case usefull = "Полезные привычки"
//    case sport = "Спорт"
}

final class TrackerRepo {
    
    static let shared = TrackerRepo()
    
    private var daysList = ["5 дней"]
    
      var categoriesList = [TrackerCategory(title: .usefull, tracker: [
        Tracker(id: UUID(), title: "Выучить Swift", color: .ypColor2, emoji: "🧑🏻‍💻", schedule: nil, category: .usefull),
//        Tracker(id: UUID(), title: "Отправить 10 резюме", color: .ypColor11, emoji: "💼", schedule: nil, category: .usefull),
//        Tracker(id: UUID(), title: "Выпить пива", color: .ypColor18, emoji: "🍺", schedule: nil, category: .usefull)
    ])]
    
    
    func createNewTracker(tracker: Tracker) {
        var trackers: [Tracker] = []
        guard let list = categoriesList.first else {return}
        for tracker in list.tracker{
            trackers.append(tracker)
        }
        trackers.append(tracker)
        categoriesList = [TrackerCategory(title: .usefull, tracker: trackers)]
        daysList.append("0 дней")
    }
    
    
    
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

