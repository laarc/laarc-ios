//
//  LaarcUserViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/12/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LaarcUserViewController: UIViewController {
    var loginView: LaarcLoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LaarcLoginView.instanceFromNib(frame: view.frame)
        loginView.delegate = self
        view.addSubview(loginView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let loggedIn = LaarcUserData.shared.isUserLoggedIn()
        print(loggedIn)
    }
}

extension LaarcUserViewController: LaarcAuthDelegate {
    func login(username: String, password: String) {
        LaarcUserData.shared.loginUser(username: username, password: password)
    }

    func signup(username: String, password: String, email: String?) {
        
    }
}
