//
//  LIOUtils.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

struct LIOUtils {
    static func getInfoStringFromItem(item: LIOItem) -> String {
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
        infoString.append(" | ");
        let n = item.descendants;
        if (n != nil && n! > 0) {
            infoString.append(String(n!) + " " + (n! == 1 ? "comment" : "comments"));
        } else if (item.text != nil && item.text!.count > 0) {
            infoString.append("read");
        } else {
            infoString.append("discuss");
        }
        return infoString
    }
}
