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
            categoryListView.addSubview(bottomLineView)

        }
    }

    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private var categoryList = [String]()

    static func make(frame: CGRect, categoryList: [String]) -> CategoryHeaderView {
        let view = UINib(nibName: "CategoryHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CategoryHeaderView
        view.frame = frame
        view.categoryList = categoryList
        return view
    }

    func viewDidLayoutSubviews() {
        let cell = categoryListView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: IndexPath(item: 0, section: 0)) as! CategoryHeaderCell
        //        bottomLineView.frame.origin.x = cell.frame.origin.x
        let viewHeight = CGFloat(5)
        bottomLineView.frame = CGRect(x: 0, y: categoryListView.frame.height - viewHeight,
                                      width: cell.frame.width, height: viewHeight)
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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
