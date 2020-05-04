//
//  TodoListViewController.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/03.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class TodoListViewController: UIViewController {

    @IBOutlet weak private var categoryHeaderBaseView: UIView!
    @IBOutlet weak private var todoListView: UITableView! {
        didSet {
            todoListView.tableFooterView = UIView()
            todoListView.dataSource = self
        }
    }

    let todoList: [Todo] = {
        // 仮でTodoを用意
        let todo1 = Todo(category: Category(id: 0, title: "やること"), title: "お金払う", content: "")
        let todo2 = Todo(category: Category(id: 1, title: "勉強"), title: "プログラミング", content: "")
        let todo3 = Todo(category: Category(id: 0, title: "やること"), title: "買い物いく", content: "")
        let todo4 = Todo(category: Category(id: 2, title: "趣味"), title: "サイクリング", content: "")
        let todo5 = Todo(category: Category(id: 2, title: "趣味"), title: "お金払う", content: "")
        let todo6 = Todo(category: Category(id: 1, title: "勉強"), title: "英語", content: "")
        let todo7 = Todo(category: Category(id: 3, title: "予約"), title: "レストラン", content: "")
        let todo8 = Todo(category: Category(id: 1, title: "勉強"), title: "海外旅行知識", content: "")
        let todo9 = Todo(category: Category(id: 4, title: "仕事"), title: "デイリー資料準備", content: "")
        let todo10 = Todo(category: Category(id: 4, title: "仕事"), title: "プルリクレビュー修正", content: "")
        let todo11 = Todo(category: Category(id: 5, title: "約束"), title: "デート", content: "")
        let todo12 = Todo(category: Category(id: 5, title: "約束"), title: "記念日のお祝い", content: "")
        let todo13 = Todo(category: Category(id: 6, title: "引越しの準備"), title: "光熱費の解約と切り替え", content: "")
        let todo14 = Todo(category: Category(id: 6, title: "引越しの準備"), title: "不用品処分", content: "")
        let todo15 = Todo(category: Category(id: 7, title: "ゲーム"), title: "今週の日曜日は大会", content: "")
        return [todo1, todo2, todo3, todo4, todo5, todo6, todo7, todo8, todo9, todo10, todo11, todo12, todo13, todo14, todo15]
    }()

    var displayTodo = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryList = todoList.reduce([Category](), { $0.map { $0.id }.contains($1.category.id) ? $0 : $0 + [$1.category]}).sorted { $0.id < $1.id }
        let categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero,
                                                                       size: categoryHeaderBaseView.frame.size),
                                                         categoryList: categoryList)
        categoryHeaderBaseView.addSubview(categoryHeaderView)
        categoryHeaderView.delegate = self
        displayTodo = todoList.filter { $0.category.id == 0 }
    }
}

extension TodoListViewController: CategoryHeaderViewDelegate {
    func didSelectCategory(_ category: Category) {
        displayTodo = todoList.filter { $0.category.id == category.id }
        DispatchQueue.main.async { [unowned self] in
            self.todoListView.reloadData()
        }
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayTodo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = displayTodo[indexPath.row].title
        return cell
    }
}
