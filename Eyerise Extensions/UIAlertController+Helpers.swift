//
//  UIAlertController+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    extension UIAlertController {
        ///  Easy way to present UIAlertController
        public func show() {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
        }
    }
    
#endif
