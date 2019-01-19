//
//  LIOStoryDetailTableHeader.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOStoryDetailTableHeader: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoStringLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var addCommentButton: UIButton!
    
    var item: LIOItem!
    
    class func instanceFromNib(frame: CGRect, item: LIOItem) -> LIOStoryDetailTableHeader {
        let me = UINib(nibName: "LIOStoryDetailTableHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LIOStoryDetailTableHeader
        me.item = item
        me.frame = frame
        me.titleLabel.text = me.item.title ?? "No title"
        let infoString = LIOUtils.getInfoStringFromItem(item: me.item)
        me.infoStringLabel.text = infoString
        me.buttonInsets(button: me.upvoteButton)
        me.buttonInsets(button: me.downvoteButton)
        return me
    }

    func buttonInsets(button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
}
