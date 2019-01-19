//
//  LIOCommentTableViewCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class CommentCellItem {
    var item: LIOItem!
    var isExpanded = false

    func toggleExpanded() {
        isExpanded = !isExpanded
    }
}

class LIOCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!

    class func instanceFromNib(item: LIOItem, isExpanded: Bool) -> LIOCommentTableViewCell {
        let me = UINib(nibName: "LIOCommentTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LIOCommentTableViewCell
        me.configure(item: item, isExpanded: isExpanded)
        return me
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLabel(isExpanded: Bool) {
        if isExpanded {
            commentLabel.numberOfLines = 0
            commentLabel.lineBreakMode = .byWordWrapping
        } else {
            commentLabel.numberOfLines = 3
            commentLabel.lineBreakMode = .byTruncatingTail
        }
        self.setNeedsLayout()
    }

    func configure(item: LIOItem, isExpanded: Bool) {
        commentLabel.text = item.text
    }

}
