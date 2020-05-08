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
    private var todoListPagingVC: TodoListPagingViewController!
    private var categoryHeaderView: CategoryHeaderView!

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

    var categoryList = [Category(id: 0, title: "やること"),
                        Category(id: 1, title: "勉強"),
                        Category(id: 2, title: "趣味"),
                        Category(id: 3, title: "予約"),
                        Category(id: 4, title: "仕事"),
                        Category(id: 5, title: "約束"),
                        Category(id: 6, title: "引越しの準備"),
                        Category(id: 7, title: "ゲーム")]

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero, size: categoryHeaderBaseView.frame.size),
                                                     categoryList: categoryList, selectCategoryTitleColor: .red)
        categoryHeaderView.delegate = self
        categoryHeaderBaseView.addSubview(categoryHeaderView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let todoListPagingVC = segue.destination as? TodoListPagingViewController,
            segue.identifier == "EmbedPageVC" else { return }

        self.todoListPagingVC = todoListPagingVC
        self.todoListPagingVC.todoListPagingVCDelegate = self
        self.todoListPagingVC.setup(vcArray: categoryList.map({ (category) -> ListViewController in
            let listVC = ListViewController(todoList: todoList.filter { $0.category.id == category.id })
            listVC.view.tag = category.id
            return listVC
        }))
    }
}

extension TodoListViewController: TodoListPagingViewControllerDelegate {
    func didPagingForSwipe(pageId: Int) {
        categoryHeaderView.selectCategory(at: pageId)
    }
}

extension TodoListViewController: CategoryHeaderViewDelegate {
    func didTapCategory(_ category: Category) {
        DispatchQueue.main.async { [unowned self] in
            self.todoListPagingVC.setPage(at: category.id)
        }
    }
}
