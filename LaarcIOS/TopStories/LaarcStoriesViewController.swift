//
//  LaarcStoriesViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/26/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import SwiftyComments

class FoldableStoriesViewController: LaarcStoriesViewController, CommentsViewDelegate {
    
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
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! LaarcStoryCell
        cell.animateIsFolded(fold: folded)
        (currentlyDisplayed[index] as! LaarcStory).isFolded = folded
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let selectedStory: AbstractComment = currentlyDisplayed[selectedIndex]

        // Enable cell folding for stories without replies
        if selectedStory.replies.count == 0 {
            if (selectedStory as! LaarcStory).isFolded {
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}

class LaarcStoriesViewController: CommentsViewController {

    private let storyCellId = "laarcStoryCellId"
    var stories = [LaarcStory]()
    var topStoryIds = [Int]()
    var currentPage = 1
    let itemsPerPage = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LaarcStoryCell.self, forCellReuseIdentifier: storyCellId)
        
        tableView.backgroundColor = ColorConstants.backgroundColorMed
        
        swipeToHide = true
        swipeActionAppearance.swipeActionColor = ColorConstantsAlt.accentColor
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLaarcTopStoryIds() { topStoryIds in
                self.topStoryIds.removeAll()
                self.stories.removeAll()
                self.topStoryIds = topStoryIds
                self.loadTopStoryData(id: topStoryIds[0], index: 0) {
                    DispatchQueue.main.async {
                        self.currentlyDisplayed = self.stories
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let storyCell = tableView.dequeueReusableCell(withIdentifier: storyCellId, for: indexPath) as! LaarcStoryCell
        let story = currentlyDisplayed[indexPath.row] as! LaarcStory
        storyCell.level = story.level
        storyCell.itemTitle = story.title
        storyCell.commentContent = story.text
        storyCell.posterName = story.by
        storyCell.date = story.timeAgo
        storyCell.nReplies = story.kids?.count ?? 0
        storyCell.isFolded = story.isFolded && !isCellExpanded(indexPath: indexPath)
        storyCell.storyDelegate = self
        return storyCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = ColorConstants.flashyColor
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func loadCommentViews() {
        currentlyDisplayed = stories
        tableView.reloadData()
    }

    func loadLaarcTopStoryIds(completion: @escaping (([Int]) -> Void)) {
         LIOApi.shared.getTopStoriesOnce() { idsData in
            if let idsData = idsData as? [Int], idsData.count > 0 {
               completion(idsData)
            } else {
                completion([])
            }
        }
    }
    
    func loadTopStoryData(
        id: Int, index: Int,
        completion: @escaping (() -> Void)
        ) {
        LIOApi.shared.getItem(id: id) { data in
            if let data = data as? [String: Any] {
                let storyItem = LaarcTopStory(commentData: data)

                if let kids = storyItem.kids, kids.count > 0 {
                    let topCommentId = kids[0]
                    LIOApi.shared.getItem(id: topCommentId) { commentData in
                        if let commentData = commentData as? [String: Any] {
                            storyItem.topCommentText = commentData["text"] as? String ?? ""
                        }
                        self.appendStoryCheckIndex(story: storyItem, index: index, completion: completion)
                    }
                } else {
                    self.appendStoryCheckIndex(story: storyItem, index: index, completion: completion)
                }
            }
        }
    }
    
    func appendStoryCheckIndex(
        story: LaarcStory,
        index: Int,
        completion: @escaping (() -> Void)
        ) {
        stories.append(story)
        let nextIdx = index + 1
        let upperBound = (currentPage * itemsPerPage) - 1
        
        if nextIdx < upperBound {
            let nextId = self.topStoryIds[index + 1]
            self.loadTopStoryData(id: nextId, index: index + 1, completion: completion)
        } else {
            completion()
        }
    }
    
    func showDetailView(forStoryAt index: Int) {
        guard stories.count > index else { return }

        let commentsVC = FoldableCommentsViewController()
        commentsVC.story = stories[index]
        navigationController?.pushViewController(commentsVC, animated: true)
    }
}

extension LaarcStoriesViewController: LaarcStoryDelegate {
    func expanderElementWasTapped(index: Int) {
        showDetailView(forStoryAt: index)
    }
}
