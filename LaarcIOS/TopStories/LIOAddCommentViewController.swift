//
//  LIOAddCommentViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class LIOAddCommentViewController: UIViewController, UIGestureRecognizerDelegate {

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
        if let title = item.title {
            contentLabel.text = title
        } else if let text = item.text {
            contentLabel.text = text
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        goBack()
    }
    
}
