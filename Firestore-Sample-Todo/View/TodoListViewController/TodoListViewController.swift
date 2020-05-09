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
    private let firestoreRepository = FirestoreRepositoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        firestoreRepository.readCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let categories):
                    self.categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero, size: self.categoryHeaderBaseView.frame.size),
                                                                      categoryList: categories,
                                                                      selectCategoryTitleColor: .red)
                    self.categoryHeaderView.delegate = self
                    self.categoryHeaderBaseView.addSubview(self.categoryHeaderView)

                    self.firestoreRepository.readAllCategoryTodoList { result in
                        switch result {
                        case .success(let todoList):
                            self.todoListPagingVC.setup(listVCArray: categories.map({ (category) -> ListViewController in
                                let listVC = ListViewController(categoryId: category.id,
                                                                todoList: todoList.filter { $0.categoryId == category.id })
                                return listVC
                            }))
                        case .failure(let error):
                            self.showErorrAlert(error: error)
                        }
                    }

                case .failure(let error):
                    self.showErorrAlert(error: error)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let todoListPagingVC = segue.destination as? TodoListPagingViewController,
            segue.identifier == "EmbedPageVC" else { return }
        self.todoListPagingVC = todoListPagingVC
        self.todoListPagingVC.todoListPagingVCDelegate = self
    }

    @IBAction func didTapAdd(sender: UIButton) {

    }
    
    @IBAction func didTapRefresh(sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.firestoreRepository.readAllCategoryTodoList { result in
                switch result {
                case .success(let todoList):
                    print("成功: \(todoList)")
                case .failure(let error):
                    self.showErorrAlert(error: error)
                }
            }
        }
    }

    private func showErorrAlert(error: Error? = nil) {
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let close = UIAlertAction(title: "とじる", style: .default)
        alert.addAction(close)
        present(alert, animated: true)
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
