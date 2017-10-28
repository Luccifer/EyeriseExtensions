//
//  UIButton+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UIButton {
        
        /// Convenience constructor for UIButton.
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, target: AnyObject, action: Selector) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        }
        
        /// Set a background color for the button.
        public func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
            UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
            UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
            UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
        
        /// Adds blur effect to button with selected style
        ///
        /// - Parameter style: as UIBlurEffect
        func addBlurToButton(style: UIBlurEffect) {
            let blur = UIVisualEffectView(effect: style)
            blur.frame = self.bounds
            blur.clipsToBounds = true
            blur.layer.cornerRadius = self.layer.cornerRadius
            blur.isUserInteractionEnabled = false
            self.insertSubview(blur, at: 0)
            if let imageView = self.imageView{
                self.bringSubview(toFront: imageView)
            }
        }
    }
    
#endif
