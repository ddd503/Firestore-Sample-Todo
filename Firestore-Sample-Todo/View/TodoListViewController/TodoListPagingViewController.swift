//
//  TodoListPagingViewController.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol TodoListPagingViewControllerDelegate: AnyObject {
    func movePage(listNumber: Int)
}

class TodoListPagingViewController: UIPageViewController {

    weak var todoListPagingDelegate: TodoListPagingViewControllerDelegate?
    private var pageListViewControllers = [ListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }

    func setup(listViewControllers: [ListViewController]) {
        pageListViewControllers = listViewControllers
        setViewControllers([pageListViewControllers[0]],
                           direction: .forward, animated: true, completion: nil)
    }

    func setPage(_ pageNumber: Int) {
        guard let nextVC = pageListViewControllers[safe: pageNumber],
            let currentVC = viewControllers?.first else { return }

        setViewControllers([nextVC],
                           direction: nextVC.view.tag > currentVC.view.tag ? .forward : .reverse,
                           animated: true, completion: nil)
    }

}

extension TodoListPagingViewController: UIPageViewControllerDataSource {
    // 左スワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextPageCount = viewController.view.tag + 1
        // 最終ページかどうか
        let isLastPage = nextPageCount >= pageListViewControllers.count
        return isLastPage ? nil : pageListViewControllers[nextPageCount]
    }
    // 右スワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let nextPageCount = viewController.view.tag - 1
        // 最初のページかどうか
        let isFirstPage = 0 > nextPageCount
        return isFirstPage ? nil : pageListViewControllers[nextPageCount]
    }
}

extension TodoListPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, completed, let currentVC = pageViewController.viewControllers?.first {
            todoListPagingDelegate?.movePage(listNumber: currentVC.view.tag)
        }
    }
}
