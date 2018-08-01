//
//  PlaceholderTextView.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/10/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIPlaceHolderTextView: UITextView {
    
    @IBInspectable var placeholder: String = ""
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray
    
    private let uiPlaceholderTextChangedAnimationDuration: Double = 0.05
    private let defaultTagValue = 999
    
    private var placeHolderLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil
        )
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil
        )
    }
    
    @objc private func textChanged() {
        guard !placeholder.isEmpty else {
            return
        }
        UIView.animate(withDuration: uiPlaceholderTextChangedAnimationDuration) {
            if self.text.isEmpty {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(1.0)
            }
            else {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(0.0)
            }
        }
    }
    
    override var text: String! {
        didSet{
            super.text = text
            textChanged()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if !placeholder.isEmpty {
            if placeHolderLabel == nil {
                placeHolderLabel = UILabel.init(frame: CGRect(x: 0, y: 8, width: bounds.size.width - 16, height: 0))
                placeHolderLabel!.lineBreakMode = .byWordWrapping
                placeHolderLabel!.numberOfLines = 0
                placeHolderLabel!.font = font
                placeHolderLabel!.backgroundColor = UIColor.clear
                placeHolderLabel!.textColor = placeholderColor
                placeHolderLabel!.alpha = 0
                placeHolderLabel!.tag = defaultTagValue
                self.addSubview(placeHolderLabel!)
            }
            
            placeHolderLabel!.text = placeholder
            placeHolderLabel!.sizeToFit()
            self.sendSubview(toBack: placeHolderLabel!)
            
            if text.isEmpty && !placeholder.isEmpty {
                viewWithTag(defaultTagValue)?.alpha = 1.0
            }
        }
        
        super.draw(rect)
    }
}

