//
//  TimeAgo.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/17/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

func timeAgoSinceDate(time: Double, numericDates: Bool) -> String {
    let calendar = Calendar.current
    let created = Date(timeIntervalSince1970: time)
    let now = Date()
    let set: Set<Calendar.Component> = Set([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
    let components = calendar.dateComponents(set, from: created, to: now)
    
    if (components.year ?? 0 >= 2) {
        return "\(components.year!) years ago"
    }

    if (components.year ?? 0 >= 1){
        if (numericDates) {
            return "1 year ago"
        } else {
            return "last year"
        }
    }

    if (components.month ?? 0 >= 2) {
        return "\(components.month!) months ago"
    }

    if (components.month ?? 0 >= 1){
        if (numericDates) {
            return "1 month ago"
        } else {
            return "last month"
        }
    }

    if (components.weekOfYear ?? 0 >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    }

    if (components.weekOfYear ?? 0 >= 1){
        if (numericDates) {
            return "1 week ago"
        } else {
            return "last week"
        }
    }

    if (components.day ?? 0 >= 2) {
        return "\(components.day!) days ago"
    }

    if (components.day ?? 0 >= 1){
        if (numericDates) {
            return "1 day ago"
        } else {
            return "yesterday"
        }
    }

    if (components.hour ?? 0 >= 2) {
        return "\(components.hour!) hours ago"
    }

    if (components.hour ?? 0 >= 1) {
        if (numericDates) {
            return "1 hour ago"
        } else {
            return "an hour ago"
        }
    }

    if (components.minute ?? 0 >= 2) {
        return "\(components.minute!) minutes ago"
    }

    if (components.minute ?? 0 >= 1) {
        if (numericDates) {
            return "1 minute ago"
        } else {
            return "a minute ago"
        }
    }

    if (components.second ?? 0 >= 3) {
        return "\(components.second!) seconds ago"
    }

    return "just now"
}
