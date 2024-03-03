//
//  Int +Extension.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 03/03/2024.
//

import Foundation

extension Int {
    func getFullDay() -> String {
        switch self {
        case 1:
            return "Понедельник"
        case 2:
            return "Вторник"
        case 3:
            return "Среда"
        case 4:
            return "Четверг"
        case 5:
            return "Пятница"
        case 6:
            return "Суббота"
        case 7:
            return "Воскресенье"
        default:
            return ""
        }
    }
    
    func getShortDay() -> String {
        switch self {
        case 1:
            return "Пн"
        case 2:
            return "Вт"
        case 3:
            return "Ср"
        case 4:
            return "Чт"
        case 5:
            return "Пт"
        case 6:
            return "Сб"
        case 7:
            return "Вс"
        default:
            return ""
        }
    }
}
