//
//  TodoListPagingViewController.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol TodoListPagingViewControllerDelegate: AnyObject {
    func didPagingForSwipe(pageId: Int)
}

class TodoListPagingViewController: UIPageViewController {

    private var vcArray = [UIViewController]()
    private var pageIndex = 0
    weak var todoListPagingVCDelegate: TodoListPagingViewControllerDelegate?

    func setup(vcArray: [UIViewController]) {
        self.dataSource = self
        self.delegate = self
        self.vcArray = vcArray
        setViewControllers([vcArray[pageIndex]], direction: .forward, animated: true, completion: nil)
    }

    func setPage(at menuId: Int) {
        guard let nextPageIndex = pageIndex(at: menuId) else { return }
        let direction: NavigationDirection = nextPageIndex > pageIndex ? .forward : .reverse
        pageIndex = nextPageIndex
        setViewControllers([vcArray[nextPageIndex]], direction: direction, animated: true, completion: nil)
    }

    private func pageIndex(at menuId: Int) -> Int? {
        vcArray.firstIndex(where: { $0.view.tag == menuId })
    }
}

extension TodoListPagingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let nextVC = vcArray[safe: pageIndex - 1] else { return nil }
        return nextVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nextVC = vcArray[safe: pageIndex + 1] else { return nil }
        return nextVC
    }
}

extension TodoListPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // setViewControllersを呼んでの遷移の場合は呼ばれない、スワイプのみ
        if finished, completed, let currentVC = pageViewController.viewControllers?.first,
            let currentPageIndex = pageIndex(at: currentVC.view.tag) {
            pageIndex = currentPageIndex
            todoListPagingVCDelegate?.didPagingForSwipe(pageId: currentVC.view.tag)
        }
    }
}
