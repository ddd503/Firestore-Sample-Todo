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
    let category: Category
    let title: String
    let content: String
    let editDate: Date

    init(id: String = "", category: Category, title: String, content: String = "", editDate: Date = Date()) {
        self.id = id
        self.category = category
        self.title = title
        self.content = content
        self.editDate = editDate
    }
}
