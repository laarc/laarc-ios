//
//  CommentTableViewCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/22/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOCommentTableCell: UITableViewCell {
    
    @IBOutlet weak var actionsView: UIView!
//    @IBOutlet var commentLabel: UILabel!
//    @IBOutlet var itemTitle: UILabel!
//    @IBOutlet var infoStringLabel: UILabel!

    var item: LIOItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
