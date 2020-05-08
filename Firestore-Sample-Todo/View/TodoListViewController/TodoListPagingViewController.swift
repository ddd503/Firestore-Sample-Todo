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
    private var listVCDicAtCategoryId: [Int : ListViewController] = [:]

    func setup(listVCDicAtCategoryId: [Int : ListViewController], firstCategoryId: Int) {
        dataSource = self
        delegate = self
        self.listVCDicAtCategoryId = listVCDicAtCategoryId
        guard let vc = listVCDicAtCategoryId[firstCategoryId] else { return }
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }

    func setPage(at categoryId: Int) {
        guard let nextVC = listVCDicAtCategoryId[categoryId],
            let currentVC = viewControllers?.first else { return }

        setViewControllers([nextVC],
                           direction: nextVC.view.tag > currentVC.view.tag ? .forward : .reverse,
                           animated: true, completion: nil)
    }

}

extension TodoListPagingViewController: UIPageViewControllerDataSource {
    // 右スワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let result = listVCDicAtCategoryId
            .filter { viewController.view.tag > $0.key } // 表示中のVCよりidが小さい(昇順なので右側)ものを絞る
            .max { $0.key < $1.key } // 中で一番idが大きい（表示中のVCに近いページを持つdic）ものを確定
        return result?.value
    }
    // 左スワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let result = listVCDicAtCategoryId
            .filter { $0.key > viewController.view.tag } // 表示中のVCよりidが大きい(昇順なので左側)ものを絞る
            .min { $0.key < $1.key } // 中で一番idが小さい（表示中のVCに近いページを持つdic）ものを確定
        return result?.value
    }
}

extension TodoListPagingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, completed, let currentVC = pageViewController.viewControllers?.first {
            todoListPagingDelegate?.movePage(listNumber: currentVC.view.tag)
        }
    }
}
