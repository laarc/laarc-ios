//
//  Story.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/17/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

enum ItemType: String {
    case job = "job", story = "story", comment = "comment", poll = "poll", pollopt = "pollopt"
}

struct HistoryItem: Codable {
    let by: String
    let dead: Bool
    let deleted: Bool
    let id: Int
    let kids: [Int]
    let parent: Int
    let score: Int
    let text: String
    let time: Double
    let title: String
    let type: String
    let url: String
    let accessTime: Double
    
    static func fromLaarcStory(_ item: LaarcStory) -> HistoryItem {
        let now = Date().timeIntervalSince1970
        return HistoryItem(by: item.by ?? "", dead: item.dead, deleted: item.deleted, id: item.id, kids: item.kids ?? [], parent: item.parent ?? -1, score: item.score ?? 0, text: item.text ?? "", time: item.time ?? now, title: item.title ?? "", type: item.type.rawValue, url: item.url?.absoluteString ?? "", accessTime: now)
    }
}

class LIOItem {
    private var _by: String?
    private var _dead: Bool!
    private var _deleted: Bool!
    private var _descendants: Int?
    private var _id: Int!
    private var _kids: [Int]?
    private var _parent: Int?
    private var _parts: [Int]?
    private var _poll: Int?
    private var _score: Int?
    private var _text: String?
    private var _time: Double?
    private var _title: String?
    private var _type: ItemType!
    private var _url: String?

    init(item: [String: Any]) {
        _by = item["by"] as? String
        _dead = item["dead"] as? Bool ?? false
        _deleted = item["deleted"] as? Bool ?? false
        _descendants = item["descendants"] as? Int
        _id = (item["id"] as! Int)
        _kids = item["kids"] as? [Int]
        _parent = item["parent"] as? Int
        _parts = item["parts"] as? [Int]
        _poll = item["poll"] as? Int
        _score = item["score"] as? Int
        _text = item["text"] as? String
        _time = item["time"] as? Double
        _title = item["title"] as? String
        _type = ItemType.init(rawValue: item["type"] as! String)
        _url = item["url"] as? String
    }
    
    var id: Int {
        get {
            return _id!
        }
    }
    
    var by: String? {
        get {
            return _by
        }
    }
    
    var dead: Bool {
        get {
            return _dead
        }
    }
    
    var deleted: Bool {
        get {
            return _deleted
        }
    }

    var descendants: Int? {
        get {
            return _descendants
        }
    }
    
    var kids: [Int]? {
        get {
            return _kids
        }
    }
    
    var parent: Int? {
        get {
            return _parent
        }
    }
    
    var parts: [Int]? {
        get {
            return _parts
        }
    }
    
    var poll: Int? {
        get {
            return _poll
        }
    }
    
    var score: Int? {
        get {
            return _score
        }
    }
    
    var text: String? {
        get {
            return _text
        }
    }
    
    var time: Double? {
        get {
            return _time
        }
    }
    
    var title: String? {
        get {
            return _title
        }
    }
    
    var type: ItemType {
        get {
            return _type
        }
    }
    
    var url: String? {
        get {
            return _url
        }
    }
}
