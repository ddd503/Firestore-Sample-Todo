//
//  CategoryHeaderView.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol CategoryHeaderViewDelegate: AnyObject {
    func didSelectCategory(_ category: Category)
}

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

    private var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private var categoryList = [Category]()

    weak var delegate: CategoryHeaderViewDelegate?

    static func make(frame: CGRect, categoryList: [Category]) -> CategoryHeaderView {
        let view = UINib(nibName: "CategoryHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CategoryHeaderView
        view.frame = frame
        view.categoryList = categoryList
        return view
    }

    // Viewのレイアウト完了後のタイミング（サイズが確定している想定）
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 初期表示時は(0,0)のセルに下線引く
        let cell = categoryListView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: IndexPath(item: 0, section: 0)) as! CategoryHeaderCell
        let bottomLineViewHeight = CGFloat(5)
        bottomLineView.frame = CGRect(x: 0,
                                      y: categoryListView.frame.height - bottomLineViewHeight,
                                      width: cell.frame.width,
                                      height: bottomLineViewHeight)
    }

}

extension CategoryHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath) as! CategoryHeaderCell
        cell.setInfo(categoryName: categoryList[indexPath.row].title)
        return cell
    }
}

extension CategoryHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        delegate?.didSelectCategory(categoryList[indexPath.item])
        
        let cell = categoryListView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath) as! CategoryHeaderCell
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.bottomLineView.frame.origin.x = cell.frame.origin.x
            self.bottomLineView.frame.size.width = cell.frame.width
        }
    }
}
