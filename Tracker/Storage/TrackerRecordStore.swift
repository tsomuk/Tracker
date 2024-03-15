//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 03/03/2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewRecord(from trackerRecord: TrackerRecord) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
        let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.id = trackerRecord.id
        newRecord.date = trackerRecord.date
        try! context.save()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)
            let records = try! context.fetch(fetchRequest)
            if let recordToDelete = records.first {
                context.delete(recordToDelete)
                try! context.save()
        }
    }
    
    func deleteAllRecordFor(tracker: Tracker) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let records = try context.fetch(fetchRequest)
            for recordToDelete in records {
                context.delete(recordToDelete)
            }
            try context.save()
        } catch {
            print("Error deleting records: \(error.localizedDescription)")
        }
    }

    func fetchRecords() -> [TrackerRecord] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
            let trackerRecordCoreDataArray = try! managedContext.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.map { trackerRecordCoreData in
                return TrackerRecord(
                    id: trackerRecordCoreData.id ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return trackerRecords
        }
}


