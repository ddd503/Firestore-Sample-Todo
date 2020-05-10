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
    private lazy var createTodoView: CreateTodoView = {
        CreateTodoView.make(frame: CGRect(x: 0,
                                          y: view.bounds.height,
                                          width: view.bounds.width,
                                          height: view.bounds.height))
    }()
    private let firestoreRepository = FirestoreRepositoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createTodoView)
        createTodoView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        firestoreRepository.readCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let categories):
                    self.categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero,
                                                                                    size: self.categoryHeaderBaseView.frame.size),
                                                                      categories: categories,
                                                                      selectCategoryTitleColor: .red)
                    self.categoryHeaderView.delegate = self
                    self.categoryHeaderBaseView.addSubview(self.categoryHeaderView)

                    self.firestoreRepository.readAllCategoryTodoList { result in
                        switch result {
                        case .success(let todoList):
                            self.todoListPagingVC.setup(listVCArray: categories.map({ (category) -> ListViewController in
                                let listVC = ListViewController(categoryId: category.id,
                                                                todoList: todoList.filter { $0.categoryId == category.id },
                                                                firestoreRepository: self.firestoreRepository)
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
        createTodoView.startInputTodo()
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

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue)  else {
                return
        }

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [unowned self] in
            self.createTodoView.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height + self.createTodoView.frame.height))
        }
        animator.startAnimation()
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue)  else {
                return
        }

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [unowned self] in
            self.createTodoView.transform = .identity
        }
        animator.startAnimation()
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

extension TodoListViewController: CreateTodoViewDelegate {
    func tappedCreateButton(content: String, _ completion: @escaping () -> ()) {
        guard let currentListVC = todoListPagingVC.viewControllers?.first as? ListViewController else {
            showErorrAlert()
            completion()
            return
        }

        firestoreRepository.createTodo(title: content, content: "",
                                       editDate: Date(),
                                       categoryId: currentListVC.categoryId,
                                       isDone: false) { [weak self] result in
                                        completion()
                                        guard let self = self else { return }
                                        switch result {
                                        case .success(_):
                                            print("fetch")
                                        case .failure(let error):
                                            self.showErorrAlert(error: error)
                                        }
        }
    }
}
