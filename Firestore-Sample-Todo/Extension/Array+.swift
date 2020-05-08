//
//  Array+.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/06.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
