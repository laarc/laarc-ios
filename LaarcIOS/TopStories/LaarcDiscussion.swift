//
//  Discussion.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/24/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import SwiftyComments

class LaarcDiscussion {
    var comments = [AttributedTextComment]()
    
    /**
     Builds a discussion and its comment tree.
     - parameters:
     - comments: all the comments
     - maximumChildren: maximum number of replies to a comment. This number is randomly chosen.
     */
    static func build(comments: [LaarcComment], maximumChildren: Int = -1) -> LaarcDiscussion {
        let discussion = LaarcDiscussion()
        for _ in 0..<comments.count {
            if let rootComment = comments.first {
                var rootAttrComment = parse(laarcComment: rootComment)
                addReplyRecurs(&rootAttrComment, maximumChildren: maximumChildren)
                discussion.comments.append(rootAttrComment)
            }
        }
        return discussion
    }
    
    /**
     Parse and generate a acomment
     */
    static func parse(laarcComment comment: LaarcComment) -> AttributedTextComment {
        let com = AttributedTextComment()
        com.id = comment.id
        com.text = comment.text
        com.by = comment.by
        com.time = comment.time!
        com.score = comment.score
        com.title = ""
        return com
    }
    
    /**
     Recursively add replies to the parent.
     */
    private static func addReplyRecurs( _ parent: inout AttributedTextComment, maximumChildren: Int) {
        guard
            maximumChildren > 0,
            parent.kids != nil,
            parent.kids!.count > 0 else {
                return
        }

        for _ in 0..<parent.kids!.count {
            var com = AttributedTextComment()
            parent.addReply(com)
            com.replyTo = parent
            com.level = parent.level + 1
            addReplyRecurs(&com, maximumChildren: maximumChildren - 1)
        }
    }
}

/// Model of a comment with attributedText content.
class AttributedTextComment: LaarcComment {
    var attributedContent: NSAttributedString?
}


/**
 This class models a comment with all the most
 common attributes in the commenting systems.
 It's used as an exemple through the implemented
 commenting systems.
 **/
class LaarcComment: BaseComment {
    var id: Int!
    var score: Int?
    var downvotes: Int?
    var text: String?
    var title: String?
    var by: String?
    var time: Double? // unix
    var upvoted: Bool = false
    var downvoted: Bool = false
    var isFolded: Bool = false
    var type: ItemType = .comment
    var url: URL?
    var kids: [Int]?
    var parent: Int?
    var deleted: Bool!
    var dead: Bool!
    
    convenience init(commentData: [String: Any]) {
        self.init(level: 0, replyTo: nil)
        self.by = commentData["by"] as? String
        self.score = commentData["score"] as? Int
        self.text = commentData["text"] as? String
        self.title = commentData["title"] as? String
        self.time = commentData["time"] as? Double
        self.kids = commentData["kids"] as? [Int]
        self.parent = commentData["parent"] as? Int
        self.deleted = commentData["deleted"] as? Bool ?? false
        self.dead = commentData["dead"] as? Bool ?? false
    }
    
    /**
     Express the postedDate in following format: "[x] [time period] ago"
     */
    func soMuchTimeAgo() -> String? {
        if self.time == nil {
            return nil
        }
        let diff = Date().timeIntervalSince1970 - self.time!
        var str: String = ""
        if  diff < 60 {
            str = "now"
        } else if diff < 3600 {
            let out = Int(round(diff/60))
            str = (out == 1 ? "1 minute ago" : "\(out) minutes ago")
        } else if diff < 3600 * 24 {
            let out = Int(round(diff/3600))
            str = (out == 1 ? "1 hour ago" : "\(out) hours ago")
        } else if diff < 3600 * 24 * 2 {
            str = "yesterday"
        } else if diff < 3600 * 24 * 7 {
            let out = Int(round(diff/(3600*24)))
            str = (out == 1 ? "1 day ago" : "\(out) days ago")
        } else if diff < 3600 * 24 * 7 * 4{
            let out = Int(round(diff/(3600*24*7)))
            str = (out == 1 ? "1 week ago" : "\(out) weeks ago")
        } else if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4)))
            str = (out == 1 ? "1 month ago" : "\(out) months ago")
        } else {//if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4*12)))
            str = (out == 1 ? "1 year ago" : "\(out) years ago")
        }
        return str
    }
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
}
