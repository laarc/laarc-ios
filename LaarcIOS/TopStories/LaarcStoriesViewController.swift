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
        self.fullyExpanded = false
        super.viewDidLoad()
        self.delegate = self
    }
    
    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let storyCell = super.commentsView(tableView, commentCellForModel: commentModel, atIndexPath: indexPath) as! LaarcStoryCell
        storyCell.storyDelegate = self
        storyCell.storyIndex = indexPath.row
        return storyCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailView(forStoryAt: indexPath.row)
    }
}

extension FoldableStoriesViewController: LaarcStoryDelegate {
    func expanderElementWasTapped(index: Int) {
        let selectedStory: AbstractComment = currentlyDisplayed[index]
        
        if selectedStory.replies.count == 0 {
            if (selectedStory as! LaarcStory).isFolded {
                commentCellExpanded(atIndex: index)
            } else {
                commentCellFolded(atIndex: index)
            }
        }
    }
    
    func replyButtonTapped(index: Int) {
        showDetailView(forStoryAt: index)
    }
    
    func contentCellTapped(index: Int) {
        showDetailView(forStoryAt: index)
    }
}

class LaarcStoriesViewController: CommentsViewController {

    private let storyCellId = "laarcStoryCellId"
    private let loadingCellId = "loadingCell"

    let viewModel = LaarcTopStoriesVM()
    
    var loadTimer: Timer?
    
    var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addLoader()

        tableView.register(LaarcStoryCell.self, forCellReuseIdentifier: storyCellId)

        tableView.backgroundColor = ColorConstants.backgroundColorMed
        view.backgroundColor = ColorConstantsAlt.bodyColor

        swipeToHide = true
        swipeActionAppearance.swipeActionColor = ColorConstantsAlt.accentColor

        viewModelLoad()
    }

    func viewModelLoad() {
        showLoader()
        
        tableView.reloadData {
            self.viewModel.getTopStoriesData() { topStories in
                self.currentlyDisplayed = topStories
                self.hideLoader()
                self.tableView.reloadData()
            }
        }
    }

    func addLoader() {
        let indicatorSize: CGFloat = 60
        let offset: CGFloat = indicatorSize * 0.5
        indicator = UIActivityIndicatorView(frame: CGRect(x: (view.frame.size.width * 0.5) - offset, y: (view.frame.size.height * 0.3) - offset, width: indicatorSize, height: indicatorSize))
        indicator.color = .black
        view.addSubview(indicator)
    }

    func showLoader() {
        view.bringSubviewToFront(indicator)
        indicator.startAnimating()
    }

    func hideLoader() {
        view.sendSubviewToBack(indicator)
        indicator.stopAnimating()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewSize: CGFloat = 80
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: Int(viewSize)))
        let prevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: viewSize, height: viewSize))
        let nextBtn = UIButton(frame: CGRect(x: tableView.frame.size.width - viewSize, y: 0, width: viewSize, height: viewSize))
        footer.backgroundColor = .white
        footer.addSubview(prevBtn)
        footer.addSubview(nextBtn)
        prevBtn.setTitle("prev", for: .normal)
        prevBtn.titleLabel!.font = LaarcUIUtils.primaryFont()
        prevBtn.setTitleColor(.black, for: .normal)
        prevBtn.setTitleColor(ColorConstantsAlt.metadataColor.withAlphaComponent(0.6), for: .disabled)
        prevBtn.contentVerticalAlignment = .top
        prevBtn.contentEdgeInsets.top = 4
        prevBtn.showsTouchWhenHighlighted = true
        prevBtn.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        nextBtn.setTitle("next", for: .normal)
        nextBtn.titleLabel!.font = LaarcUIUtils.primaryFont()
        nextBtn.contentVerticalAlignment = .top
        nextBtn.contentEdgeInsets.top = 4
        nextBtn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.setTitleColor(ColorConstantsAlt.metadataColor.withAlphaComponent(0.6), for: .disabled)
        nextBtn.showsTouchWhenHighlighted = true

        if viewModel.currentPage == 1 {
            prevBtn.isEnabled = false
        } else if viewModel.currentPage == viewModel.maxPages {
            nextBtn.isEnabled = false
        }

        if indicator.isAnimating {
            footer.alpha = 0
        } else {
            footer.alpha = 1
        }

        return footer
    }

    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let storyCell = tableView.dequeueReusableCell(withIdentifier: storyCellId, for: indexPath) as! LaarcStoryCell
        let story = currentlyDisplayed[indexPath.row] as! LaarcStory
        storyCell.rank = (viewModel.topStoryIds.firstIndex(of: story.id) ?? 0) + 1
        storyCell.score = story.score ?? 0
        storyCell.level = story.level
        storyCell.itemTitle = story.title
        if let text = story.text {
            let attrText = HNCommentContentParser.buildAttributedText(From: text)
            storyCell.commentContent = attrText
        }
        storyCell.posterName = story.by
        storyCell.date = story.timeAgo
        storyCell.nReplies = story.kids?.count ?? 0
        storyCell.isFolded = story.isFolded && !isCellExpanded(indexPath: indexPath)
        return storyCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = ColorConstantsAlt.accentColor
        self.navigationController?.navigationBar.tintColor = .black
    }

    func clearTableThenLoad(inDirection: PaginateDir) {
        currentlyDisplayed = []
        tableView.reloadData() {
            self.viewModelLoad()
        }
    }

    @objc func handleNext() {
        let lastPage = viewModel.currentPage
        viewModel.paginate(inDirection: .next)
        if lastPage != viewModel.currentPage {
            tableView.scrollToTop(animated: false)
            clearTableThenLoad(inDirection: .next)
        }
    }
    
    @objc func handlePrev() {
        let lastPage = viewModel.currentPage
        viewModel.paginate(inDirection: .prev)
        if lastPage != viewModel.currentPage {
            tableView.scrollToTop(animated: false)
            clearTableThenLoad(inDirection: .prev)
        }
    }

    func showDetailView(forStoryAt index: Int) {
        guard currentlyDisplayed.count > index else { return }

        if let focusingItem = currentlyDisplayed[index] as? LaarcStory {
            LIOApi.shared.getItem(id: focusingItem.id) { item in
                if let item = item as? [String: Any] {
                    let story = LaarcStory(commentData: item)
                    let commentsVC = FoldableCommentsViewController()
                    commentsVC.story = story
                    self.navigationController?.pushViewController(commentsVC, animated: true)
                }
            }
        }
    }
}
