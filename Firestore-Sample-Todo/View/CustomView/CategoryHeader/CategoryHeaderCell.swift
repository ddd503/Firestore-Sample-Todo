//
//  CategoryHeaderCell.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class CategoryHeaderCell: UICollectionViewCell {

    @IBOutlet weak private var categoryNameLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setInfo(categoryName: String) {
        categoryNameLabel.text = categoryName
    }
}
