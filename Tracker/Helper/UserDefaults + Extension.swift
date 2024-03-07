//
//  UserDefaults + Extension.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 06/03/2024.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
            return true
        }
        return false
    }
}
