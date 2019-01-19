//
//  LIODownvoteButton.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIODownvoteButton: UIButton {

    class func instanceFromNib(frame: CGRect, item: LIOItem) -> LIODownvoteButton {
        let me = UINib(nibName: "LIODownvoteButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LIODownvoteButton
        return me
    }
    
}
