//
//  ListViewController.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    @IBOutlet weak private var listView: UITableView! {
        didSet {
            listView.dataSource = self
            listView.register(ListViewCell.nib(), forCellReuseIdentifier: ListViewCell.identifier)
            listView.tableFooterView = UIView()
        }
    }

    let categoryId: String
    private var todoList = [Todo]()

    init(categoryId: String, todoList: [Todo]) {
        self.categoryId = categoryId
        self.todoList = todoList
        super.init(nibName: "ListViewController", bundle: .main)
    }

    required init?(coder: NSCoder) {
        return nil
    }

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as! ListViewCell
        cell.setInfo(title: todoList[indexPath.row].title)
        return cell
    }
}
