//
//  RedditCommentsViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/24/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import SwiftyComments

let commentsToLoad = 30

class FoldableCommentsViewController: LaarcCommentsViewController, CommentsViewDelegate {

    let headerIdenfifiter = "storyHeaderCellId"

    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }

    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! LaarcCommentCellAlt
        cell.animateIsFolded(fold: folded)
        (currentlyDisplayed[index] as! AttributedTextComment).isFolded = folded
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self
    }

//    func makeHeaderView() -> LaarcStoryHeader {
//        let header = LaarcStoryHeader(style: UITableViewCell.CellStyle.default, reuseIdentifier: headerIdenfifiter)
//        header.itemTitle = story.title
//        header.itemText = story.text
//        let infoString = LIOUtils.getInfoStringFromItem(item: story)
//        header.postInfo = infoString
//        return header
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let selectedCom: AbstractComment = currentlyDisplayed[selectedIndex]

        // Enable cell folding for comments without replies
        if selectedCom.replies.count == 0 {
            if (selectedCom as! LaarcComment).isFolded {
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}

class LaarcCommentsViewController: CommentsViewController {
    private let commentCellId = "hnComentCellId"
    var allComments = [AttributedTextComment]()

    var story: LaarcStory!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LaarcCommentCellAlt.self, forCellReuseIdentifier: commentCellId)

        tableView.backgroundColor = ColorConstantsAlt.bodyColor

        swipeToHide = true
        swipeActionAppearance.swipeActionColor = ColorConstantsAlt.accentColor

        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLaarcCommentData() { laarcComments in
                self.allComments.removeAll()
                self.allComments.append(contentsOf: laarcComments)
                self.generateAttributedTexts(for: self.allComments)
                DispatchQueue.main.async {
                    self.currentlyDisplayed = self.allComments
                    self.tableView.reloadData()
                }
            }
        }
    }

    func generateAttributedTexts(for comments: [AttributedTextComment]) {
        for com in comments {
            com.attributedContent = HNCommentContentParser.buildAttributedText(From: com.text ?? "")
            self.generateAttributedTexts(for: com.replies as! [AttributedTextComment])
        }
    }

    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! LaarcCommentCellAlt
        let comment = currentlyDisplayed[indexPath.row] as! AttributedTextComment
        commentCell.level = comment.level
        commentCell.commentContentAttributed = comment.attributedContent
        commentCell.posterName = comment.by
        commentCell.date = comment.timeAgo
        commentCell.nReplies = comment.kids?.count ?? 0
        commentCell.isFolded = comment.isFolded && !isCellExpanded(indexPath: indexPath)
        return commentCell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = ColorConstantsAlt.accentColor
        self.navigationController?.navigationBar.tintColor = .black
    }

    func loadCommentViews() {
        currentlyDisplayed = LaarcDiscussion.build(comments: allComments).comments
        tableView.reloadData()
    }

    func loadLaarcCommentData(completion: @escaping (([AttributedTextComment]) -> Void)) {
        guard let storyId = story.id else { return }

        LIOApi.shared.getItem(id: storyId) { data in
            var laarcComments = [AttributedTextComment]()

            if let data = data as? [String: Any] {
                let storyItem = LIOItem(item: data)
                if let kids = storyItem.kids {
                    for i in 0..<kids.count {
                        LIOApi.shared.getItem(id: kids[i]) { commentData in
                            if let commentData = commentData as? [String: Any] {
                                let comment = AttributedTextComment(commentData: commentData)
                                laarcComments.append(comment)
                            }

                            if i == kids.count - 1 {
                               completion(laarcComments)
                            }
                        }
                    }
                } else {
                    completion([])
                }
            }
        }
    }
}


