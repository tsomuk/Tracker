//
//  TrackerStruct.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 11/01/2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule?

    
    struct Schedule {
        var schedule: [Weekday]?
    }
}
