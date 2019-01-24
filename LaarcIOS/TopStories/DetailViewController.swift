//
//  DetailViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/22/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var item: LIOItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")
        // TODO: visible, loaded comments views
        if let text = item.text {
            cell?.textLabel?.text = text
        }
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
}
