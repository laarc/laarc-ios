//
//  RedditCommentCell.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/24/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import SwiftyComments

struct ColorConstants {
    static let sepColor = #colorLiteral(red: 0.9686660171, green: 0.9768124223, blue: 0.9722633958, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.9961144328, green: 1, blue: 0.9999337792, alpha: 1)
    static let backgroundColorMed = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    static let commentMarginColor = ColorConstants.backgroundColor
    static let rootCommentMarginColor = #colorLiteral(red: 0.9332661033, green: 0.9416968226, blue: 0.9327681065, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.929128468, green: 0.9298127294, blue: 0.9208832383, alpha: 1)
    static let metadataFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let metadataColor = #colorLiteral(red: 0.6823018193, green: 0.682382822, blue: 0.6822645068, alpha: 1)
    static let textFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let textColor = #colorLiteral(red: 0.4042215049, green: 0.4158815145, blue: 0.4158077836, alpha: 1)
    static let controlsColor = #colorLiteral(red: 0.7295756936, green: 0.733242631, blue: 0.7375010848, alpha: 1)
    static let flashyColor = #colorLiteral(red: 0.1220618263, green: 0.8247511387, blue: 0.7332885861, alpha: 1)
}

class LaarcCommentCell: CommentCell {
    private var content: LaarcCommentView {
        get {
            return commentViewContent as! LaarcCommentView
        }
    }

    open var commentContent: String! {
        get {
            return content.commentContent
        } set(value) {
            content.commentContent = value
        }
    }

    open var posterName: String! {
        get {
            return content.posterName
        } set(value) {
            content.posterName = value
        }
    }

    open var date: String! {
        get {
            return content.date
        } set(value) {
            content.date = value
        }
    }

    open var upvotes: Int! {
        get {
            return content.upvotes
        } set(value) {
            content.upvotes = value
        }
    }

    open var isFolded: Bool {
        get {
            return content.isFolded
        } set(value) {
            content.isFolded = value
        }
    }

    // change the value of the isFolded property, add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.content.backgroundColor = ColorConstants.flashyColor.withAlphaComponent(0.06)
        }, completion: { (done) in
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.content.backgroundColor = ColorConstants.backgroundColor
            }, completion: nil)
        })
        content.isFolded = fold
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commentViewContent = LaarcCommentView()
        backgroundColor = ColorConstants.backgroundColor
        commentMarginColor = ColorConstants.commentMarginColor
        rootCommentMargin = 8
        rootCommentMarginColor = ColorConstants.rootCommentMarginColor
        indentationIndicatorColor = ColorConstants.identationColor
        commentMargin = 0
        isIndentationIndicatorsExtended = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LaarcCommentView: UIView {
    open var commentContent: String! = "content" {
        didSet {
            contentLabel.text = commentContent
        }
    }

    open var posterName: String! = "username" {
        didSet {
            updateUsernameLabel()
        }
    }

    open var date: String! = "" {
        didSet {
            updateUsernameLabel()
        }
    }

    open var upvotes: Int! = 42 {
        didSet {
            upvotesLabel.text = "\(upvotes!)"
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

    private func updateUsernameLabel() {
        posterLabel.text = "\(posterName!) • \(date!)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fold() {
        contentHeightConstraint?.isActive = true
        controlBarHeightConstraint?.isActive = true
        controlView.isHidden = true
    }

    private func unfold() {
        contentHeightConstraint?.isActive = false
        controlBarHeightConstraint?.isActive = false
        controlView.isHidden = false
    }

    private var contentHeightConstraint: NSLayoutConstraint?

    private var controlBarHeightConstraint: NSLayoutConstraint?
    
    private func setLayout() {
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        posterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        contentLabel.topAnchor.constraint(equalTo: posterLabel.bottomAnchor, constant: 3).isActive = true
        contentHeightConstraint = contentLabel.heightAnchor.constraint(equalToConstant: 0)
        setupControlView()

        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
        controlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        controlBarHeightConstraint = controlView.heightAnchor.constraint(equalToConstant: 0)
    }

    private func setupControlView() {
        let sep1 = UIView()
        sep1.backgroundColor = ColorConstants.sepColor
        let sep2 = UIView()
        sep2.backgroundColor = ColorConstants.sepColor

        controlView.addSubview(downvoteButton)
        controlView.addSubview(upvotesLabel)
        controlView.addSubview(upvoteButton)
        controlView.addSubview(replyButton)
        controlView.addSubview(moreBtn)
        controlView.addSubview(sep1)
        controlView.addSubview(sep2)
        
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        sep1.translatesAutoresizingMaskIntoConstraints = false
        sep2.translatesAutoresizingMaskIntoConstraints = false
        
        downvoteButton.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -10).isActive = true
        downvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        downvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvotesLabel.trailingAnchor.constraint(equalTo: downvoteButton.leadingAnchor, constant: -10).isActive = true
        upvotesLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvotesLabel.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvoteButton.trailingAnchor.constraint(equalTo: upvotesLabel.leadingAnchor, constant: -10).isActive = true
        upvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep1.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep1.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep1.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep1.trailingAnchor.constraint(equalTo: upvoteButton.leadingAnchor, constant: -10).isActive = true
        
        replyButton.trailingAnchor.constraint(equalTo: sep1.leadingAnchor, constant: -10).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep2.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep2.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep2.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep2.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -10).isActive = true
        
        moreBtn.trailingAnchor.constraint(equalTo: sep2.leadingAnchor, constant: -10).isActive = true
        moreBtn.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        moreBtn.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        moreBtn.leadingAnchor.constraint(equalTo: controlView.leadingAnchor).isActive = true
        
    }

    let controlView = UIView()

    let moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "more").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConstants.controlsColor
        return btn
    }()

    let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Reply", for: .normal)
        btn.setTitleColor(ColorConstants.controlsColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.setImage(#imageLiteral(resourceName: "hnRespond").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConstants.controlsColor
        return btn
    }()

    let upvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "imgurUp").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConstants.controlsColor
        return btn
    }()

    let upvotesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = ColorConstants.controlsColor
        lbl.text = "42"
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()

    let downvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "imgurDown").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConstants.controlsColor
        return btn
    }()

    let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = ColorConstants.textColor
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = ColorConstants.textFont
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()

    let posterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = ColorConstants.metadataColor
        lbl.font = ColorConstants.metadataFont
        lbl.textAlignment = .left
        return lbl
    }()
}

