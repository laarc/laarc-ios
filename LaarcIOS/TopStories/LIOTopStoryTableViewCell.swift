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
    
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }

    
    func configure(item: LIOItem, number: Int) {
        numberLabel.text = String(number) + "."
        titleLabel.text = item.title ?? "No title"
        let infoString = LIOUtils.getInfoStringFromItem(item: item)
        itemInfoLabel.text = infoString
        ;
    }

}
