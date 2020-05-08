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
    
    func setInfo(categoryName: String) {
        categoryNameLabel.text = categoryName
    }
    /// タイトルカラーを変更する
    /// - Parameter color: タイトルカラー
    func setTitleColor(_ color: UIColor) {
        categoryNameLabel.textColor = color
    }
}
