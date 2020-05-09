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

    override func viewDidLoad() {
        super.viewDidLoad()
        let repo = FireStoreRepositoryImpl()
        repo.readCategories { result in
            switch result {
            case .success(let categories):
                print("成功: \(categories)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero, size: self.categoryHeaderBaseView.frame.size),
                                                                 categoryList: categories, selectCategoryTitleColor: .red)
                    self.categoryHeaderView.delegate = self
                    self.categoryHeaderBaseView.addSubview(self.categoryHeaderView)
                }
            case .failure(let error):
                print("失敗：\(error.localizedDescription)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let todoListPagingVC = segue.destination as? TodoListPagingViewController,
            segue.identifier == "EmbedPageVC" else { return }

        self.todoListPagingVC = todoListPagingVC
        self.todoListPagingVC.todoListPagingVCDelegate = self
//        self.todoListPagingVC.setup(vcArray: categoryList.map({ (category) -> ListViewController in
//            let listVC = ListViewController(todoList: todoList.filter { $0.category.id == category.id })
//            listVC.view.tag = category.id
//            return listVC
//        }))
    }

    @IBAction func didTapAdd(sender: UIButton) {
        let repo = FireStoreRepositoryImpl()
        repo.createCategory(title: "やること", editDate: Date()) { result in
            switch result {
            case .success(_):
                print("成功")
            case .failure(let error):
                print("失敗：\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func didTapRefresh(sender: UIButton) {
        let repo = FireStoreRepositoryImpl()
        repo.readCategories { result in
            switch result {
            case .success(let categories):
                print("成功: \(categories)")
            case .failure(let error):
                print("失敗：\(error.localizedDescription)")
            }
        }
    }
}

extension TodoListViewController: TodoListPagingViewControllerDelegate {
    func didPagingForSwipe(pageId: String) {
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
