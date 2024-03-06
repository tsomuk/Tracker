//
//  CollectionCellHelper.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 21/02/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
