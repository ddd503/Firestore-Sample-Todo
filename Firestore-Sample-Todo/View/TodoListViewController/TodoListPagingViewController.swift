//
//  TodoListPagingViewController.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol TodoListPagingViewControllerDelegate: AnyObject {
    func didPagingForSwipe(pageId: String)
}

class TodoListPagingViewController: UIPageViewController {

    private var listVCArray = [ListViewController]()
    private var pageIndex = 0
    weak var todoListPagingVCDelegate: TodoListPagingViewControllerDelegate?

    func setup(listVCArray: [ListViewController]) {
        self.dataSource = self
        self.delegate = self
        self.listVCArray = listVCArray
        setViewControllers([listVCArray[pageIndex]], direction: .forward, animated: true, completion: nil)
    }

    func setPage(at categoryId: String) {
        guard let nextPageIndex = pageIndex(at: categoryId) else { return }
        let direction: NavigationDirection = nextPageIndex > pageIndex ? .forward : .reverse
        pageIndex = nextPageIndex
        setViewControllers([listVCArray[nextPageIndex]], direction: direction, animated: true, completion: nil)
    }

    private func pageIndex(at categoryId: String) -> Int? {
        listVCArray.firstIndex(where: { $0.categoryId == categoryId })
    }
}

extension TodoListPagingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let nextVC = listVCArray[safe: pageIndex - 1] else { return nil }
        return nextVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nextVC = listVCArray[safe: pageIndex + 1] else { return nil }
        return nextVC
    }
}

extension TodoListPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // setViewControllersを呼んでの遷移の場合は呼ばれない、スワイプのみ
        if finished, completed, let currentVC = pageViewController.viewControllers?.first as? ListViewController,
            let currentPageIndex = pageIndex(at: currentVC.categoryId) {
            pageIndex = currentPageIndex
            todoListPagingVCDelegate?.didPagingForSwipe(pageId: currentVC.categoryId)
        }
    }
}
