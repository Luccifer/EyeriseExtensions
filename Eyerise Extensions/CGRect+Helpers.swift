//
//  CGRect+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension CGRect {
        /// Easier initialization of CGRect
        public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
            self.init(x: x, y: y, width: w, height: h)
        }
        
        /// X value of CGRect's origin
        public var x: CGFloat {
            get {
                return self.origin.x
            } set(value) {
                self.origin.x = value
            }
        }
        
        /// Y value of CGRect's origin
        public var y: CGFloat {
            get {
                return self.origin.y
            } set(value) {
                self.origin.y = value
            }
        }
        
        /// Width of CGRect's size
        public var w: CGFloat {
            get {
                return self.size.width
            } set(value) {
                self.size.width = value
            }
        }
        
        /// Height of CGRect's size
        public var h: CGFloat {
            get {
                return self.size.height
            } set(value) {
                self.size.height = value
            }
        }
        
        /// Surface Area represented by a CGRectangle
        public var area: CGFloat {
            return self.h * self.w
        }
    }
    
#endif
