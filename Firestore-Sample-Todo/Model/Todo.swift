//
//  Todo.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import Foundation

struct Todo {
    let category: Category
    let title: String
    let content: String
}

struct Category {
    let id: Int
    let title: String
}
