//
//  LaarcLoginView.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/12/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

protocol LaarcAuthDelegate {
    func login(username: String, password: String) -> Void
    func signup(username: String, password: String, email: String?) -> Void
}

class LaarcLoginView: UIView {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delegate: LaarcAuthDelegate?

    class func instanceFromNib(frame: CGRect) -> LaarcLoginView {
        let me = UINib(nibName: "LaarcLoginView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LaarcLoginView
        me.frame = frame
        return me
    }

    @IBAction func loginAction(_ sender: Any) {
        if let username = usernameField.text, let password = passwordField.text {
            delegate?.login(username: username, password: password)
        }
    }
}
