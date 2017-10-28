//
//  UISwitch+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS)
    
    import UIKit
    
    public extension UISwitch {
        
        /// toggles Switch
        public func toggle() {
            self.setOn(!self.isOn, animated: true)
        }
    }
    
#endif
