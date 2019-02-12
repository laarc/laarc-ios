//
//  LaarcCommentCellAlt.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/26/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit
import SwiftyComments

struct ColorConstantsAlt {
    static let sepColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
    static let posterColor = #colorLiteral(red: 0.4, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    static let accentColor = #colorLiteral(red: 0.6039215686, green: 0.7294117647, blue: 0.6666666667, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    static let commentMarginColor = #colorLiteral(red: 0.6039215686, green: 0.7294117647, blue: 0.6666666667, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
    static let textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let rootCommentMarginColor = #colorLiteral(red: 0.6039215686, green: 0.7294117647, blue: 0.6666666667, alpha: 1)
    static let metadataColor = #colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1)
    static let bodyColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.937254902, alpha: 1)
}

class LaarcCommentCellAlt: CommentCell {
    open var cellDelegate: CommentCellDelegate? {
        get {
            return self.content.cellDelegate
        } set (value) {
            self.content.cellDelegate = value
        }
    }

    open var comment: LaarcComment? {
        get {
            return self.content.comment
        } set (value) {
            self.content.comment = value
        }
    }

    var content: LaarcCommentViewAlt {
        get {
            return self.commentViewContent as! LaarcCommentViewAlt
        }
    }

    open var commentContentAttributed: NSAttributedString? {
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
        self.commentViewContent = LaarcCommentViewAlt()
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

class LaarcCommentViewAlt: UIView {
    open var body: NSAttributedString? {
        didSet {
            self.bodyView.attributedText = body
        }
    }
    
    open var posterName: String? {
        didSet {
            self.usernameView.setTitle(posterName, for: .normal)
        }
    }
    
    open var date: String! {
        didSet {
            self.createdView.text = date
        }
    }
    
    open var nReplies: Int! {
        didSet {
            if nReplies > 0 {
                self.nRepliesLabel.text = "\(nReplies!) replies"
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
    
    open var comment: LaarcComment?
    
    open var cellDelegate: CommentCellDelegate?
    
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
    
    private var bodyViewHeightConstraint: NSLayoutConstraint?
    private var controlBarHeightConstraint: NSLayoutConstraint?
    
    
    private let HMargin: CGFloat = 8
    private let VMargin: CGFloat = 8

    func setupLayout() {
        self.addSubview(usernameView)
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        usernameView.topAnchor.constraint(equalTo: self.topAnchor, constant: VMargin).isActive = true
        usernameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
        self.addSubview(createdView)
        createdView.translatesAutoresizingMaskIntoConstraints = false
        createdView.leadingAnchor.constraint(equalTo: usernameView.trailingAnchor, constant: 5).isActive = true
        createdView.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        
        self.addSubview(nRepliesLabel)
        nRepliesLabel.translatesAutoresizingMaskIntoConstraints = false
        nRepliesLabel.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        nRepliesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        
        self.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.topAnchor.constraint(equalTo: usernameView.bottomAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        bodyViewHeightConstraint = bodyView.heightAnchor.constraint(equalToConstant: 0)
        
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
        replyBtn.addTarget(self, action: #selector(onReply(_:)), for: .touchUpInside)
        
        controlBarContainerView.addSubview(upvoteBtn)
        upvoteBtn.translatesAutoresizingMaskIntoConstraints = false
        upvoteBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        upvoteBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        upvoteBtn.trailingAnchor.constraint(equalTo: replyBtn.leadingAnchor, constant: -15).isActive = true
        upvoteBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        upvoteBtn.leadingAnchor.constraint(equalTo: controlBarContainerView.leadingAnchor).isActive = true
        
        self.addSubview(controlBarContainerView)
        controlBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlBarContainerView.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 5).isActive = true
        controlBarContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        controlBarContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -VMargin).isActive = true
        
    }

    @objc func onReply(_ sender: Any?) {
        cellDelegate?.onAddReply(self.comment)
    }

    let controlBarContainerView = UIView()
    
    let nRepliesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = ColorConstantsAlt.metadataColor
        lbl.font = LaarcUIUtils.primaryFont(13, ofWeight: .thin)
        return lbl
    }()

    let upvoteBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hadUpvote").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("", for: .normal)
        
        btn.titleLabel!.font = LaarcUIUtils.primaryFont(12, ofWeight: .thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        btn.contentHorizontalAlignment = .right
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()

    let replyBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hnRespond").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("reply", for: .normal)
        
        btn.titleLabel!.font = LaarcUIUtils.primaryFont(12, ofWeight: .thin)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = ColorConstantsAlt.metadataColor
        
        return btn
    }()
    
    let bodyView: UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
//        lbl.font = LaarcUIUtils.primaryFont(14, ofWeight: .medium)
        return lbl
    }()
    
    let usernameView: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Anonymous", for: .normal)
        btn.setTitleColor(ColorConstantsAlt.metadataColor, for: .normal)
        btn.titleLabel!.font = LaarcUIUtils.primaryFont(17, ofWeight: .semibold)
        return btn
    }()

    let createdView: UILabel = {
        let lbl = UILabel()
        lbl.text = "6 days ago"
        lbl.textColor = ColorConstantsAlt.metadataColor
        lbl.font = LaarcUIUtils.primaryFont(13, ofWeight: .thin)
        return lbl
    }()
    
}




