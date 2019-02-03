//
//  LaarcStoryCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/26/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import SwiftyComments

protocol LaarcStoryDelegate {
    func expanderElementWasTapped(index: Int)
    func replyButtonTapped(index: Int)
    func contentCellTapped(index: Int)
}

fileprivate let maxTitleChars = 160

class LaarcStoryCell: CommentCell {
    var storyDelegate: LaarcStoryDelegate?
    var storyIndex: Int!

    open var rank: Int {
        get {
            return self.content.rank
        } set (value) {
            self.content.rank = value
        }
    }

    open var score: Int {
        get {
            return self.content.score
        } set (value) {
           self.content.score = value
        }
    }

    var content: LaarcStoryCellView {
        get {
            return self.commentViewContent as! LaarcStoryCellView
        }
    }
    
    var itemTitle: String? {
        get {
            return self.content.title
        } set (value) {
            self.content.title = value
        }
    }

    open var commentContent: NSAttributedString? {
        get {
            return self.content.body
        } set(value) {
            self.content.body = value
        }
    }
    
    open var posterName: String! {
        get {
            return self.content.posterName
        } set(value) {
            self.content.posterName = value
        }
    }
    
    open var date: String! {
        get {
            return self.content.date
        } set(value) {
            self.content.date = value
        }
    }
    
    open var nReplies: Int! {
        get {
            return self.content.nReplies
        } set(value) {
            self.content.nReplies = value
        }
    }
    
    open var upvoted: Bool {
        get {
            return self.content.upvoted
        } set(value) {
            self.content.upvoted = value
        }
    }
    
    open var isFolded: Bool {
        get {
            return self.content.isFolded
        } set(value) {
            self.content.isFolded = value
        }
    }
    
    // change the value of the isFolded property, add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.content.backgroundColor = ColorConstantsAlt.accentColor.withAlphaComponent(0.1)
        }, completion: { (done) in
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.content.backgroundColor = .white
            }, completion: nil)
        })
        self.content.isFolded = fold
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = LaarcStoryCellView()
        (self.commentViewContent as! LaarcStoryCellView).rank = rank
        self.backgroundColor = .white
        self.commentMarginColor = ColorConstantsAlt.bodyColor
        self.indentationIndicatorColor = ColorConstantsAlt.identationColor
        self.rootCommentMarginColor = ColorConstantsAlt.bodyColor
        self.indentationColor = ColorConstantsAlt.bodyColor
        self.commentMargin = 0
        self.setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func expanderElementTappedAction(_ sender: Any?) {
        storyDelegate?.expanderElementWasTapped(index: storyIndex)
    }
    
    @objc func replyButtonTapped(_ sender: Any?) {
        storyDelegate?.expanderElementWasTapped(index: storyIndex)
    }

    @objc func cellContentTapped(_ sender: Any?) {
        storyDelegate?.contentCellTapped(index: storyIndex)
    }
    
    func setupGestures() {
        content.replyBtn.addTarget(self, action: #selector(replyButtonTapped(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellContentTapped(_:)))
        content.bodyView.addGestureRecognizer(tap)
        content.titleView.addGestureRecognizer(tap)
    }
}

class LaarcStoryCellView: UIView {
    open var body: NSAttributedString? {
        didSet {
            self.bodyView.attributedText = body

            if bodyView.attributedText.length == 0 {
                bodyViewHeightConstraint?.isActive = true
            }
        }
    }
    
    open var rank: Int = 0

    open var score: Int  = 0 {
        didSet {
            if (score > 0) {
                 self.upvoteBtn.setTitle(String(score), for: .normal)
            } else {
                 self.upvoteBtn.setTitle("Upvote", for: .normal)
            }
        }
    }

    open var title: String? {
        didSet {
            let rankStr = String(rank)
            self.titleView.text = "\(rankStr). \(title ?? "")"
        }
    }
    
    open var posterName: String? {
        didSet {
            self.usernameView.setTitle("by \(posterName ?? "?")", for: .normal)
        }
    }
    
    open var date: String! {
        didSet {
            self.createdView.text = date
        }
    }
    
    open var nReplies: Int! {
        didSet {
            let repliesText = nReplies == 1 ? "reply" : "replies"

            if nReplies > 0 {
                self.nRepliesLabel.text = "\(nReplies!) \(repliesText)"
            } else {
                self.nRepliesLabel.text = ""
            }
            
        }
    }

    open var upvoted: Bool = false {
        didSet {
            self.upvoteBtn.tintColor = upvoted ? #colorLiteral(red: 0.08024211973, green: 0.7872473598, blue: 0.2486046553, alpha: 1) : ColorConstantsAlt.metadataColor
        }
    }

    open var isFolded: Bool! = false {
        didSet {
            if isFolded {
                fold()
            } else {
                unfold()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fold() {
        bodyViewHeightConstraint?.isActive = true
        controlBarHeightConstraint?.isActive = true
        controlBarContainerView.isHidden = true
    }
    
    private func unfold() {
        bodyViewHeightConstraint?.isActive = false
        controlBarHeightConstraint?.isActive = false
        controlBarContainerView.isHidden = false
    }
    
    private var titleViewHeightConstraint: NSLayoutConstraint?
    private var bodyViewHeightConstraint: NSLayoutConstraint?
    private var controlBarHeightConstraint: NSLayoutConstraint?
    
    private let HMargin: CGFloat = 8
    private let VMargin: CGFloat = 8
    
    func setupLayout() {
        self.addSubview(nRepliesLabel)
        nRepliesLabel.translatesAutoresizingMaskIntoConstraints = false
        nRepliesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: VMargin).isActive = true
        nRepliesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: HMargin * -2).isActive = true
        
        self.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: nRepliesLabel.bottomAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        titleViewHeightConstraint = titleView.heightAnchor.constraint(equalToConstant: 0)
        titleViewHeightConstraint?.isActive = false

        self.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        bodyViewHeightConstraint = bodyView.heightAnchor.constraint(equalToConstant: 0)
        
        self.addSubview(usernameView)
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        usernameView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        usernameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin * 2).isActive = true
        usernameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        usernameView.contentHorizontalAlignment = .left
        
        self.addSubview(createdView)
        createdView.translatesAutoresizingMaskIntoConstraints = false
        createdView.leadingAnchor.constraint(equalTo: usernameView.trailingAnchor, constant: 5).isActive = true
        createdView.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
 
        setupControlBar()
        controlBarHeightConstraint = controlBarContainerView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    /// Add Upvote & Reply buttons (and helper labels) to the view
    private func setupControlBar() {
        controlBarContainerView.backgroundColor = .white


        controlBarContainerView.addSubview(replyBtn)
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        replyBtn.trailingAnchor.constraint(equalTo: controlBarContainerView.trailingAnchor).isActive = true
        replyBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        controlBarContainerView.addSubview(upvoteBtn)
        upvoteBtn.translatesAutoresizingMaskIntoConstraints = false
        upvoteBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        upvoteBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        upvoteBtn.trailingAnchor.constraint(equalTo: replyBtn.leadingAnchor, constant: -15).isActive = true
        upvoteBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.addSubview(controlBarContainerView)
        controlBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlBarContainerView.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 5).isActive = true
        controlBarContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        controlBarContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -VMargin).isActive = true
    }
    
    let controlBarContainerView = UIView()
    
    let nRepliesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 reply"
        lbl.textColor = ColorConstantsAlt.metadataColor
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.thin)
        return lbl
    }()

    let upvoteBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hadUpvote").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Upvote", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()

    let replyBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hnRespond").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Reply", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()
    
    let titleView: UITextView = {
        let title = UITextView()
        title.isEditable = false
        title.isScrollEnabled = false
        title.textAlignment = .left
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        return title
    }()

    let bodyView: UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    let usernameView: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Anonymous", for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()

    let createdView: UILabel = {
        let lbl = UILabel()
        lbl.text = "6 days ago"
        lbl.textColor = ColorConstantsAlt.metadataColor
        lbl.font = UIFont.italicSystemFont(ofSize: 12)
        return lbl
    }()
}

class LaarcStoryHeader: CommentCell {
    var content: LaarcStoryHeaderView {
        get {
            return self.commentViewContent as! LaarcStoryHeaderView
        }
    }
    
    var itemTitle: String? {
        get {
            return self.content.title
        } set (value) {
            self.content.title = value
        }
    }

    var itemText: String? {
        get {
            return self.content.text
        } set (value) {
            self.content.text = value
        }
    }

    open var postInfo: String? {
        get {
            return self.content.postInfo
        } set(value) {
            self.content.postInfo = value
        }
    }
    
    open var title: String! {
        get {
            return self.content.title
        } set(value) {
            self.content.title = value
        }
    }
    
//    open var date: String! {
//        get {
//            return self.content.date
//        } set(value) {
//            self.content.date = value
//        }
//    }
    
    open var nReplies: Int! {
        get {
            return self.content.nReplies
        } set(value) {
            self.content.nReplies = value
        }
    }

    // change the value of the isFolded property, add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.content.backgroundColor = ColorConstantsAlt.accentColor.withAlphaComponent(0.1)
        }, completion: { (done) in
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.content.backgroundColor = .white
            }, completion: nil)
        })
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = LaarcStoryCellView()
        self.backgroundColor = .white
        self.commentMarginColor = ColorConstantsAlt.bodyColor
        self.indentationIndicatorColor = ColorConstantsAlt.identationColor
        self.rootCommentMarginColor = ColorConstantsAlt.bodyColor
        self.indentationColor = ColorConstantsAlt.bodyColor
        self.commentMargin = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LaarcStoryHeaderView: UIView {
    open var postInfo: String? {
        didSet {
            self.infoView.text = postInfo
        }
    }

    open var text: String? {
        didSet {
            self.textView.text = text
        }
    }

    open var title: String? {
        didSet {
            self.titleView.setTitle(title, for: .normal)
        }
    }

    open var date: String! {
        didSet {
//            self.createdView.text = date
        }
    }

    open var nReplies: Int! {
        didSet {
//            let repliesText = nReplies == 1 ? "reply" : "replies"
            
//            if nReplies > 0 {
//                self.nRepliesLabel.text = "\(nReplies!) \(repliesText)"
//            } else {
//                self.nRepliesLabel.text = ""
//            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let HMargin: CGFloat = 8
    private let VMargin: CGFloat = 8

    func setupLayout() {
        self.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: VMargin).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
//        self.addSubview(createdView)
//        createdView.translatesAutoresizingMaskIntoConstraints = false
//        createdView.leadingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 5).isActive = true
//        createdView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//
//        self.addSubview(nRepliesLabel)
//        nRepliesLabel.translatesAutoresizingMaskIntoConstraints = false
//        nRepliesLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//        nRepliesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
        self.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        infoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
        setupControlBar()
    }

    /// Add Upvote & Reply buttons (and helper labels) to the view
    private func setupControlBar() {
        controlBarContainerView.backgroundColor = .white
        controlBarContainerView.addSubview(replyBtn)
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        replyBtn.trailingAnchor.constraint(equalTo: controlBarContainerView.trailingAnchor).isActive = true
        replyBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        controlBarContainerView.addSubview(upvoteBtn)
        upvoteBtn.translatesAutoresizingMaskIntoConstraints = false
        upvoteBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        upvoteBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        upvoteBtn.trailingAnchor.constraint(equalTo: replyBtn.leadingAnchor, constant: -15).isActive = true
        upvoteBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        upvoteBtn.leadingAnchor.constraint(equalTo: controlBarContainerView.leadingAnchor).isActive = true
        
        self.addSubview(controlBarContainerView)
        controlBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlBarContainerView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 5).isActive = true
        controlBarContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        controlBarContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -VMargin).isActive = true
    }

    let controlBarContainerView = UIView()
    
//    let nRepliesLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "0 reply"
//        lbl.textColor = ColorConstantsAlt.metadataColor
//        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.thin)
//        return lbl
//    }()
    
    let upvoteBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hadUpvote").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Upvote", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()
    
    let replyBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hnRespond").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Reply", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()
    
    let textView: UITextView = {
        let title = UITextView()
        title.isEditable = false
        title.isScrollEnabled = false
        title.textAlignment = .left
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return title
    }()
    
    let infoView: UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
        lbl.font = UIFont.italicSystemFont(ofSize: 12)
        return lbl
    }()
    
    let titleView: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Anonymous", for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        return btn
    }()
    
//    let createdView: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "6 days ago"
//        lbl.textColor = ColorConstantsAlt.metadataColor
//        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.thin)
//        return lbl
//    }()
}
