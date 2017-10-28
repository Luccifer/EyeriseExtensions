//
//  UITextView+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UITextView {
        
        /// Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
        /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, font = ThemeFontName
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            font = UIFont.systemFont(ofSize: fontSize)
            backgroundColor = UIColor.clear
            clipsToBounds = true
            textAlignment = NSTextAlignment.left
            isUserInteractionEnabled = true
            
            #if os(iOS)
                
                isEditable = false
                
            #endif
            
            isScrollEnabled = false
        }
        
        #if os(iOS)
        
        /// Automatically adds a toolbar with a done button to the top of the keyboard. Tapping the button will dismiss the keyboard.
        public func addDoneButton(_ barStyle: UIBarStyle = .default, title: String? = nil) {
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: title ?? "Done", style: .done, target: self, action: #selector(resignFirstResponder))
            ]
            
            keyboardToolbar.barStyle = barStyle
            keyboardToolbar.sizeToFit()
            
            inputAccessoryView = keyboardToolbar
        }
        
        #endif
    }
    
#endif
