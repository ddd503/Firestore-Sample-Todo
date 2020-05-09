//
//  ListViewCell.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/04.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol ListViewCellDelegate: AnyObject {
    func tappedCheckButton(with todo: Todo)
}

final class ListViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var checkButton: UIButton!
    private var todo: Todo?
    weak var delegate: ListViewCellDelegate?

    @IBAction func tappedCheckButton(sender: UIButton) {
        guard var todo = todo else { return }
        todo.isDone.toggle()
        updateCheckButtonAppearance(by: todo.isDone)
        self.todo = todo
        delegate?.tappedCheckButton(with: todo)
    }

    func setInfo(todo: Todo) {
        titleLabel.text = todo.title
        updateCheckButtonAppearance(by: todo.isDone)
        self.todo = todo
    }

    private func updateCheckButtonAppearance(by isDoneTodo: Bool) {
        checkButton.tintColor = isDoneTodo ? .blue : .lightGray
        checkButton.setBackgroundImage(UIImage(systemName: isDoneTodo ? "checkmark.circle" : "circle", compatibleWith: nil), for: .normal)
    }
}
