//
//  ListViewCell.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class ListViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var checkMarkImageView: UIImageView!

    func setInfo(title: String) {
        titleLabel.text = title
    }
}
