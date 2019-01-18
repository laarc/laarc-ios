//
//  LIOTopStoryDetailViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOTopStoryDetailViewController: UIViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    var item: LIOItem!
    var number: Int!

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleItem.title = String(number)
        doneButton.action = #selector(goBack)
        // Do any additional setup after loading the view.
    }
}
