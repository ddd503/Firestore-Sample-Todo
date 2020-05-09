//
//  Category.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/09.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

struct Category {
    let id: String
    let title: String
    let editDate: Date

    init(id: String = "", title: String, editDate: Date = Date()) {
        self.id = id
        self.title = title
        self.editDate = editDate
    }
}
