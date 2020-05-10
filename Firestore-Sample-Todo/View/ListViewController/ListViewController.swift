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
    private let firestoreRepository: FirestoreRepository

    init(categoryId: String, todoList: [Todo], firestoreRepository: FirestoreRepository) {
        self.categoryId = categoryId
        self.todoList = todoList
        self.firestoreRepository = firestoreRepository
        super.init(nibName: "ListViewController", bundle: .main)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listView.isHidden = todoList.isEmpty
        let topBorder = CALayer()
        topBorder.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 1))
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        view.layer.addSublayer(topBorder)
    }

    func refreshTodoList(_ todoList: [Todo]) {
        self.todoList = todoList
        listView.reloadData()
        listView.isHidden = todoList.isEmpty
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as! ListViewCell
        cell.setInfo(todo: todoList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ListViewController: ListViewCellDelegate {
    func tappedCheckButton(with todo: Todo) {
        firestoreRepository.updateTodoStatus(todo, nil)
    }
}
