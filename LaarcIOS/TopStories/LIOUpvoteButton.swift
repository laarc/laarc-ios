//
//  LIOUpvoteButton.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOUpvoteButton: UIButton {

    class func instanceFromNib(frame: CGRect, item: LIOItem) -> LIOUpvoteButton {
        let me = UINib(nibName: "LIOUpvoteButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LIOUpvoteButton
        return me
    }

}
