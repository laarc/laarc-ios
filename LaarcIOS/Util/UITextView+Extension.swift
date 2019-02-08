//
//  UITextView+Extension.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/7/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Methods
public extension UITextView {
    
    /// clear text.
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// scroll to the bottom of text view
    public func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    /// scroll to the top of text view
    public func scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
    
    /// wrap to the content (text / attributed text).
    public func wrapToContent() {
        contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
        contentOffset = CGPoint.zero
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }
    
    /// Add padding to the left of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the text view rect.
    public func addPaddingLeft(_ padding: CGFloat) {
        self.textContainerInset.left = padding
    }
    
    /// Add padding to the right of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the right of the text view rect.
    public func addPaddingRight(_ padding: CGFloat) {
        self.textContainerInset.right = padding
    }

    /// Add padding to the top of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the top of the text view rect.
    public func addPaddingTop(_ padding: CGFloat) {
        self.textContainerInset.top = padding
    }
    
    /// Add padding to the bottom of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the bottom of the text view rect.
    public func addPaddingBottom(_ padding: CGFloat) {
        self.textContainerInset.bottom = padding
    }
    
    /// Add padding to the top/btm of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the top/btm of the text view rect.
    public func addPaddingVertical(_ padding: CGFloat) {
        self.textContainerInset.top = padding
        self.textContainerInset.bottom = padding
    }
    
    /// Add padding to the left/right of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left/right of the text view rect.
    public func addPaddingHorizontal(_ padding: CGFloat) {
        self.textContainerInset.left = padding
        self.textContainerInset.right = padding
    }
    
    /// Add padding to the top/btm/l/r of the text view rect.
    ///
    /// - Parameter padding: amount of padding to apply to the top/btm/l/r of the text view rect.
    public func addPadding(_ padding: CGFloat) {
        self.textContainerInset.top = padding
        self.textContainerInset.bottom = padding
        self.textContainerInset.left = padding
        self.textContainerInset.right = padding
    }
    
    /// Set a max number of text lines, or pass nothing to allow expand to fit text content size.
    ///   - parameter max: Max number of lines, or 0 for auto
    public func setLineMax(_ max: Int = 0) {
        self.textContainer.maximumNumberOfLines = max
        if max > 0 {
            self.textContainer.lineBreakMode = .byTruncatingTail
        }
    }
}
