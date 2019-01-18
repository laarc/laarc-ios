//
//  LIOTopStoryTableViewCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/17/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOTopStoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: LIOItem, number: Int) {
        numberLabel.text = String(number)
        titleLabel.text = item.title ?? "No title"
        var infoString = ""
        if let score = item.score {
            let pointsString = score == 1 ? "point" : "points"
            infoString.append(contentsOf: "\(score) \(pointsString) ")
        }
        if let by = item.by {
            infoString.append(contentsOf: "by \(by) ")
        }
        if let time = item.time {
            let timeAgo = timeAgoSinceDate(time: time, numericDates: true)
            infoString.append(contentsOf: timeAgo)
        }
        itemInfoLabel.text = infoString
    }

}
