//
//  UIView+XIB.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/06.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
