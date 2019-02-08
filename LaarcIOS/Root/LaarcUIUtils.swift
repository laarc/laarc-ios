//
//  LaarcUIUtils.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/7/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import UIKit

struct LaarcUIUtils {
    static func primaryFont(_ size: CGFloat = 15, ofWeight weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "Verdana", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
