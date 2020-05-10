//
//  CreateTodoView.swift
//  Firestore-Sample-Todo
//
//  Created by kawaharadai on 2020/05/10.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

protocol CreateTodoViewDelegate: AnyObject {
    func tappedCreateButton(content: String, _ completion: @escaping () -> ())
}

class CreateTodoView: UIView {

    @IBOutlet weak private var inputTextView: UITextView! {
        didSet { inputTextView.delegate = self }
    }
    @IBOutlet weak private var inputTextViewContainer: UIView!
    @IBOutlet weak private var actionButton: UIButton!
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextViewContainerHeightConstraint: NSLayoutConstraint!

    weak var delegate: CreateTodoViewDelegate?
    private var currentTextViewHeight: CGFloat = 33
    private let maxTextViewHeight: CGFloat = 80
    private let minTextViewHeight: CGFloat = 33

    static func make(frame: CGRect) -> CreateTodoView {
        let view = UINib(nibName: "CreateTodoView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! CreateTodoView
        view.frame = frame
        return view
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        inputTextView.layer.masksToBounds = true
        inputTextView.layer.cornerRadius = 5
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        actionButton.layer.masksToBounds = true
        actionButton.layer.cornerRadius = 5
        let topBorder = CALayer()
        topBorder.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 1))
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        inputTextViewContainer.layer.addSublayer(topBorder)
    }

    @IBAction func tappedActionButton(sender: UIButton) {
        if inputTextView.text.isEmpty {
            inputTextView.resignFirstResponder()
        } else {
            delegate?.tappedCreateButton(content: inputTextView.text) { [weak self] in
                self?.inputTextView.text = ""
                self?.endEditing(true)
            }
        }
    }

    @IBAction func tappedBackgroundView(_ sender: UITapGestureRecognizer) {
        endEditing(true)
    }

    func startInputTodo() {
        inputTextView.becomeFirstResponder()
    }

    private func adjustInputTextViewFrameWhenTextViewDidChange(variableHeight: CGFloat) {
        // IB側のinputTextViewに対する制約を再現する（一度autoLayoutを解除するため）
        inputTextView.frame = CGRect(x: 20, y: 15, width: self.frame.width - 40, height: variableHeight)
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

    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = inputTextView.contentSize.height
        if minTextViewHeight <= contentHeight && contentHeight <= maxTextViewHeight {
            inputTextView.translatesAutoresizingMaskIntoConstraints = true
            inputTextView.sizeToFit()
            inputTextView.isScrollEnabled = false
            let resizedHeight = inputTextView.frame.size.height
            inputTextViewHeightConstraint.constant = resizedHeight

            adjustInputTextViewFrameWhenTextViewDidChange(variableHeight: resizedHeight)

            if resizedHeight > currentTextViewHeight {
                let addingHeight = resizedHeight - currentTextViewHeight
                inputTextViewContainerHeightConstraint.constant += addingHeight
                currentTextViewHeight = resizedHeight
            } else if resizedHeight < currentTextViewHeight {
                let subtractingHeight = currentTextViewHeight - resizedHeight
                inputTextViewContainerHeightConstraint.constant -= subtractingHeight
                currentTextViewHeight = resizedHeight
            }
        } else {
            inputTextView.isScrollEnabled = true
            inputTextViewHeightConstraint.constant = currentTextViewHeight
            adjustInputTextViewFrameWhenTextViewDidChange(variableHeight: currentTextViewHeight)
        }
    }
}
