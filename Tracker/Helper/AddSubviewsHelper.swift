//
//  CollectionCellHelper.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 21/02/2024.
//

import UIKit

extension UICollectionViewCell {
    func addSubviewsInCell(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}

extension UIView {
    func addSubviewsinView(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
