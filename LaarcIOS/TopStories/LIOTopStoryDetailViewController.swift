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
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    
    var item: LIOItem!
    var number: Int!

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.action = #selector(goBack)
        itemTitleLabel.text = item.title
        let infoString = LIOUtils.getInfoStringFromItem(item: item)
        itemInfoLabel.text = infoString
        buttonInsets(button: upvoteButton)
        buttonInsets(button: downvoteButton)
        // Do any additional setup after loading the view.
    }
    
    func buttonInsets(button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    @objc func infoLabelPressed() {
        
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
    }
}
