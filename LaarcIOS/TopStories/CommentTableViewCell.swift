//
//  CommentTableViewCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/22/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

let ipsum = "Lorem ipsum dolor amet hammock polaroid tote bag, succulents tbh anim mustache shaman paleo in. Microdosing mixtape vape id, shoreditch enim bitters in heirloom pug single-origin coffee cornhole. Enamel pin tilde pok pok, disrupt listicle schlitz officia dolore beard chillwave vice vinyl. Migas lyft culpa enamel pin officia minim readymade, ullamco est lorem incididunt VHS master cleanse."

class CommentTableCell: UITableViewCell {
    
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var itemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
