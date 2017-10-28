//
//  UILabel+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UILabel {
        
        /// Initialize Label with a font, color and alignment.
        public convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
            self.init()
            self.font = font
            self.textColor = color
            self.textAlignment = alignment
        }
        
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat = 17) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            font = UIFont.systemFont(ofSize: fontSize)
            backgroundColor = UIColor.clear
            clipsToBounds = true
            textAlignment = NSTextAlignment.left
            isUserInteractionEnabled = true
            numberOfLines = 1
        }
        
        public func getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
            return sizeThatFits(CGSize(width: width, height: height))
        }
        
        /// if duration set to 0 animate wont be
        public func set(text _text: String?, duration: TimeInterval) {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
                self.text = _text
            }, completion: nil)
        }
    }
    
#endif
