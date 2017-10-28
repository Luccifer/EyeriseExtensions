//
//  UIScreen+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension UIScreen {
    
    enum DeviceType {
        case inch4, inch4_7, inch5_5, Unknown
    }
    
    /// Check the device using
    ///
    /// - Returns: DeviceType.enum
    class func deviceType() -> DeviceType {
        switch UIScreen.main.bounds.width {
        case 320:
            return .inch4
        case 375:
            return .inch4_7
        case 414:
            return .inch5_5
        default:
            return .Unknown
        }
    }
    
    /// Checks if device is iphone4
    ///
    class func isIphone4() -> Bool {
        return UIScreen.main.bounds.height == 480
    }
    
    /// Checks if device is iphone4
    ///
    class func isIphone5() -> Bool {
        return UIScreen.main.bounds.height == 568
    }
    
    /// Checks if device is iphone4
    ///
    class func isIphone6() -> Bool {
        return UIScreen.main.bounds.height == 667
    }
    
    /// Checks if device is iphone4
    ///
    class func isIphonePlus() -> Bool {
        return UIScreen.main.bounds.height == 736
    }
}
