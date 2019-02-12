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

    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var infoTextView: UITextView!

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
        textContent.attributedText = attrText
        
        var infoString = ""
        if let by = item.by {
            infoString += "by \(by) "
        }
        if let time = item.time {
            infoString += "\(timeAgoSinceDate(time: time, numericDates: true))"
        }

        infoTextView.text = infoString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textContent.scrollRectToVisible(CGRect.zero, animated: false)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        goBack()
    }
    
}
