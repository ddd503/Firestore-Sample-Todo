//
//  CategoryHeaderView.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol CategoryHeaderViewDelegate: AnyObject {
    func didTapCategory(_ category: Category)
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
        }
    }
    
    /// イニシャライザ
    /// - Parameters:
    ///   - frame: frame
    ///   - menus: リスト表示するメニューの配列
    ///   - selectMenuTitleColor: 選択中のメニュータイトルの色
    static func make(frame: CGRect, categoryList: [Category], selectCategoryTitleColor: UIColor) -> CategoryHeaderView {
        let view = UINib(nibName: "CategoryHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CategoryHeaderView
        view.frame = frame
        view.categoryList = categoryList
        view.selectCategoryTitleColor = selectCategoryTitleColor
        return view
    }
    
    private var bottomLineView = UIView()
    private var categoryList = [Category]()
    private var selectCategoryTitleColor = UIColor.black
    weak var delegate: CategoryHeaderViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let firstSelectIndexPath = IndexPath(item: 0, section: 0)
        bottomLineView.backgroundColor = selectCategoryTitleColor
        bottomLineView.frame = bottomLineViewFrame(by: firstSelectIndexPath)
        categoryListView.addSubview(bottomLineView)
        selectCategory(at: firstSelectIndexPath, animated: false)
    }
    
    func selectCategory(at categoryId: String) {
        guard let selectIndexPath = categoryIndex(at: categoryId) else { return }
        deselectCategoryIfNeeded()
        selectCategory(at: selectIndexPath)
    }
    
    private func bottomLineViewFrame(by indexPath: IndexPath) -> CGRect {
        let selectCell = categoryListView.cellForItem(at: indexPath) ?? categoryListView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath)
        let bottomLineViewHeight = CGFloat(2)
        return CGRect(x: selectCell.frame.origin.x,
                      y: categoryListView.frame.height - bottomLineViewHeight,
                      width: selectCell.frame.width,
                      height: bottomLineViewHeight)
    }
    
    private func categoryIndex(at categoryId: String) -> IndexPath? {
        let result = categoryList.firstIndex { $0.id == categoryId }
        guard let index = result else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    private func selectCategory(at indexPath: IndexPath, animated: Bool = true) {
        guard let selectCell = CategoryHeaderCellForItem(at: indexPath) else { return }
        // この処理後にデリゲートメソッド（didSelectItemAt）を呼ばないからdidSelectItemAtから読んでも大丈夫
        categoryListView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
        selectCell.setTitleColor(selectCategoryTitleColor)
        moveBottomLine(at: indexPath, animated: true)
    }
    
    private func deselectCategoryIfNeeded(at indexPath: IndexPath? = nil) {
        guard let deselectIndexPath = indexPath ?? categoryListView.indexPathsForSelectedItems?.first,
            let deselectCell = CategoryHeaderCellForItem(at: deselectIndexPath) else { return }
        // この処理後にデリゲートメソッド（didDeselectItemAt）を呼ばないからdidDeselectItemAtから読んでも大丈夫
        categoryListView.deselectItem(at: deselectIndexPath, animated: false)
        deselectCell.setTitleColor(.black)
    }
    
    private func CategoryHeaderCellForItem(at indexPath: IndexPath) -> CategoryHeaderCell? {
        // 表示されているセル取得用で取れなければ、再利用手法で作り直して返す
        categoryListView.cellForItem(at: indexPath) as? CategoryHeaderCell ??
            categoryListView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath) as? CategoryHeaderCell
    }
    
    private func moveBottomLine(at indexPath: IndexPath, animated: Bool) {
        let execute = { [unowned self] in
            self.bottomLineView.frame = self.bottomLineViewFrame(by: indexPath)
        }
        animated ? UIView.animate(withDuration: 0.2, animations: execute) : execute()
    }
}

extension CategoryHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryHeaderCell.identifier, for: indexPath) as! CategoryHeaderCell
        cell.setInfo(categoryName: categoryList[indexPath.row].title)
        let titleColor: UIColor = categoryListView.indexPathsForSelectedItems?.first == indexPath ? selectCategoryTitleColor : .black
        cell.setTitleColor(titleColor)
        return cell
    }
}

extension CategoryHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCategory(at: indexPath)
        delegate?.didTapCategory(categoryList[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectCategoryIfNeeded(at: indexPath)
    }
}
