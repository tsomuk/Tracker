//
//  NSLocalizedString + Postfix.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 09/03/2024.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
