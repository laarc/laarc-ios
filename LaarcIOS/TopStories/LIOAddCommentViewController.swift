//
//  LIOAddCommentViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class LIOAddCommentViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    
    let inputBar = InputBarAccessoryView()
    
    var item: LIOItem!

    private var keyboardManager = KeyboardManager()

    override var inputAccessoryView: UIView? {
        return inputBar
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var labelText = ""
        if let title = item.title, title.count > 0 {
            labelText = title
        } else if let text = item.text {
            labelText = text
        }
        let attrText = HNCommentContentParser.buildAttributedText(From: labelText)
        contentLabel.attributedText = attrText
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        goBack()
    }
    
}
