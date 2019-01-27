//
//  LIOUtils.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

struct LIOUtils {
    static func getInfoString(score: Int?, by: String?, time: Double?) -> String {
        var infoString = ""
        if let score = score {
            let pointsString = score == 1 ? "point" : "points"
            infoString.append(contentsOf: "\(score) \(pointsString) ")
        }
        if let by = by {
            infoString.append(contentsOf: "by \(by) ")
        }
        if let time = time {
            let timeAgo = timeAgoSinceDate(time: time, numericDates: true)
            infoString.append(contentsOf: timeAgo)
        }
        return infoString
    }

    static func getInfoStringFromItem(item: LIOItem) -> String {
        return getInfoString(score: item.score, by: item.by, time: item.time)
    }

    static func getInfoStringFromItem(item: LaarcComment) -> String {
        return getInfoString(score: item.score, by: item.by, time: item.time)
    }
    
    static func getInfoStringFromItem(item: LaarcStory) -> String {
        return getInfoString(score: item.score, by: item.by, time: item.time)
    }
}
