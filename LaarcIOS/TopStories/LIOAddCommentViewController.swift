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

    let inputBar = InputBarAccessoryView()

    private var keyboardManager = KeyboardManager()

    override var inputAccessoryView: UIView? {
        return inputBar
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(inputBar)
    }
    
}
