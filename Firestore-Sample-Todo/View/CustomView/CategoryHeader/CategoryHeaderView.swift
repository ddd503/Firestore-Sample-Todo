//
//  CategoryHeaderView.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

final class CategoryHeaderView: UIView {

    @IBOutlet weak private var categoryListView: UICollectionView! {
        didSet {
            categoryListView.dataSource = self
            categoryListView.delegate = self
            categoryListView.register(CategoryHeaderCell.nib(),
                                      forCellWithReuseIdentifier: CategoryHeaderCell.identifier)
            let layout = UICollectionViewFlowLayout()
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.scrollDirection = .horizontal
            categoryListView.collectionViewLayout = layout
        }
    }

    private var categoryList = [String]()

    static func make(frame: CGRect, categoryList: [String]) -> CategoryHeaderView {
        let view = UINib(nibName: "CategoryHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CategoryHeaderView
        view.frame = frame
        view.categoryList = categoryList
        return view
    }
}

extension CategoryHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath) as! CategoryHeaderCell
        cell.setInfo(categoryName: categoryList[indexPath.row])
        return cell
    }
}

extension CategoryHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categoryList[indexPath.row])
    }
}
