//
//  CreateTodoView.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/10.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol CreateTodoViewDelegate: AnyObject {
    func tappedCreateButton(content: String)
}

class CreateTodoView: UIView {

    @IBOutlet weak private var inputTextView: UITextView! {
        didSet { inputTextView.delegate = self }
    }
    @IBOutlet weak private var actionButton: UIButton!
    weak var delegate: CreateTodoViewDelegate?

    static func make(frame: CGRect) -> CreateTodoView {
        let view = UINib(nibName: "CreateTodoView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CreateTodoView
        view.frame = frame
        return view
    }

    @IBAction func tappedActionButton(sender: UIButton) {
        if inputTextView.text.isEmpty {
            inputTextView.resignFirstResponder()
        } else {
            delegate?.tappedCreateButton(content: inputTextView.text)
        }
    }

    func startInputTodo() {
        inputTextView.becomeFirstResponder()
    }
    
}

extension CreateTodoView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.actionButton.setTitle(self.inputTextView.text.isEmpty ? "とじる" : "作成", for: .normal)
            }
        }
        return true
    }
}
