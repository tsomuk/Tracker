//
//  TrackerStore.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 03/03/2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private let context: NSManagedObjectContext
        
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(from tracker: Tracker) -> TrackerCoreData? {
        guard let trackerCoreData = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else { return nil }
        let newTracker = TrackerCoreData(entity: trackerCoreData, insertInto: context)
        newTracker.id = tracker.id
        newTracker.title = tracker.title
        newTracker.color = UIColorMarshalling.hexString(from: tracker.color)
        newTracker.emoji = tracker.emoji
        newTracker.schedule = tracker.schedule as NSArray?
        newTracker.trackerCategory = tracker.trackerCategory
        return newTracker
    }
    
    func fetchTracker() -> [Tracker] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackerCoreDataArray = try! managedContext.fetch(fetchRequest)
        let trackers = trackerCoreDataArray.map { trackerCoreData in
            return Tracker(
                id: trackerCoreData.id ?? UUID(),
                title: trackerCoreData.title ?? "",
                color: UIColorMarshalling.color(from: trackerCoreData.color ?? ""),
                emoji: trackerCoreData.emoji ?? "",
                schedule: [],
                trackerCategory: trackerCoreData.trackerCategory ?? "")
        }
        return trackers
    }
    
    func fetchTracker2() -> [TrackerCoreData] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackerCoreDataArray = try! managedContext.fetch(fetchRequest)
        return trackerCoreDataArray
    }
    
    func deleteTracker(tracker: Tracker) {
        let targetTrackers = fetchTracker2()
        if let index = targetTrackers.firstIndex(where: {$0.id == tracker.id}) {
            context.delete(targetTrackers[index])
        }
    }
    
    func decodingTrackers(from trackersCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackersCoreData.id, let title = trackersCoreData.title,
              let color = trackersCoreData.color, let emoji = trackersCoreData.emoji else { return nil }
        return Tracker(id: id, title: title, color: UIColorMarshalling.color(from: color), emoji: emoji, schedule: trackersCoreData.schedule as! [Int], trackerCategory: trackersCoreData.trackerCategory ?? "")
    }
}

final class UIColorMarshalling {
    static func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    static func color(from hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
