//
//  Todo.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

struct Todo {
    let id: String
    let title: String
    let content: String
    let editDate: Date
    let category: Category

    init(id: String = "", title: String, content: String = "", editDate: Date = Date(), category: Category) {
        self.id = id
        self.title = title
        self.content = content
        self.editDate = editDate
        self.category = category
    }
}
