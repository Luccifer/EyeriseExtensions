//
//  UIColor+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    private class func colorComponentsFrom(string: NSString, start: Int, length: Int) -> Float {
        NSMakeRange(start, length)
        let subString = string.substring(with: NSMakeRange(start, length))
        var hexValue: UInt32 = 0
        Scanner(string: subString).scanHexInt32(&hexValue)
        return Float(hexValue) / 255.0
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    public func hexString(_ includeAlpha: Bool = true) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UIColor {
        /// init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
        public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
        }
        
        /// init method with hex string and alpha(default: 1)
        public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
            var formatted = hexString.replacingOccurrences(of: "0x", with: "")
            formatted = formatted.replacingOccurrences(of: "#", with: "")
            if let hex = Int(formatted, radix: 16) {
                let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
                let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
                let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
                self.init(red: red, green: green, blue: blue, alpha: alpha)        } else {
                return nil
            }
        }
        
        /// init method from Gray value and alpha(default:1)
        public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
            self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
        }
        
        /// Red component of UIColor (get-only)
        public var redComponent: Int {
            var r: CGFloat = 0
            getRed(&r, green: nil, blue: nil, alpha: nil)
            return Int(r * 255)
        }
        
        /// Green component of UIColor (get-only)
        public var greenComponent: Int {
            var g: CGFloat = 0
            getRed(nil, green: &g, blue: nil, alpha: nil)
            return Int(g * 255)
        }
        
        /// blue component of UIColor (get-only)
        public var blueComponent: Int {
            var b: CGFloat = 0
            getRed(nil, green: nil, blue: &b, alpha: nil)
            return Int(b * 255)
        }
        
        /// Alpha of UIColor (get-only)
        public var alpha: CGFloat {
            var a: CGFloat = 0
            getRed(nil, green: nil, blue: nil, alpha: &a)
            return a
        }
        
        /// Returns random UIColor with random alpha(default: false)
        public static func random(randomAlpha: Bool = false) -> UIColor {
            let randomRed = CGFloat.random()
            let randomGreen = CGFloat.random()
            let randomBlue = CGFloat.random()
            let alpha = randomAlpha ? CGFloat.random() : 1.0
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        }
        
    }
    
#endif
