//
//  UIWindow+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    extension UIWindow {
        /// Creates and shows UIWindow. The size will show iPhone4 size until you add launch images with proper sizes.
        public convenience init(viewController: UIViewController, backgroundColor: UIColor) {
            self.init(frame: UIScreen.main.bounds)
            self.rootViewController = viewController
            self.backgroundColor = backgroundColor
            self.makeKeyAndVisible()
        }
    }
    
#endif
