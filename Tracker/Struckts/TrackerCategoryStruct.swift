//
//  TrackerCategoryStruct.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 11/01/2024.
//

import Foundation

struct TrackerCategoryStruct {
    let category : Category
    
    
    struct Category {
        let title: String
        let tracker : [TrackerStruct]
    }
}
