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
    @IBOutlet weak private var todoListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryHeaderView = CategoryHeaderView.make(frame: CGRect(origin: .zero,
                                                                       size: categoryHeaderBaseView.frame.size),
                                                         categoryList: ["みかん",
                                                                        "りんご",
                                                                        "バナナ",
                                                                        "キウイ",
                                                                        "パイナップル",
                                                                        "ぶどう"])
        categoryHeaderBaseView.addSubview(categoryHeaderView)
    }
    
}
