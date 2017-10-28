//
//  Int+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension Int {
    
    /// Getting the minutes value in Integer format and rest of the seconds
    ///
    /// - Parameter seconds: Check closure
    /// - Returns: closure with minutes and seconds
    func minutesFrom(seconds: Int, completion: @escaping ( _ minutes: Int, _ seconds: Int)->()) {
        completion((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    /// Converts to string
    public var toString: String {
        return "\(self)"
    }
    
    /// Converts to string with Roman number representation
    ///
    /// - Returns: Roman value of year
    public var toRomanString: String {
        let huns: [String] = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"]
        let tens: [String] = ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"]
        let ones: [String] = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]
        
        var value = self
        var res: String = ""
        while value >= 1000 {
            res += "M"
            value -= 1000
        }
        
        res += huns[value / 100]
        value = value % 100
        res += tens[value / 10]
        value = value % 10
        res += ones[value]
        return res
    }
}

public extension Int {
    
    /// Checks if the integer is even.
    public var isEven: Bool { return (self % 2 == 0) }
    
    /// Checks if the integer is odd.
    public var isOdd: Bool { return (self % 2 != 0) }
    
    /// Checks if the integer is positive.
    public var isPositive: Bool { return (self > 0) }
    
    /// Checks if the integer is negative.
    public var isNegative: Bool { return (self < 0) }
    
    /// Converts integer value to Double.
    public var toDouble: Double { return Double(self) }
    
    /// Converts integer value to Float.
    public var toFloat: Float { return Float(self) }
    
    /// Converts integer value to CGFloat.
    public var toCGFloat: CGFloat { return CGFloat(self) }
    
    /// Converts integer value to UInt.
    public var toUInt: UInt { return UInt(self) }
    
    /// Converts integer value to Int32.
    public var toInt32: Int32 { return Int32(self) }
    
    /// Converts integer value to a 0..<Int range. Useful in for loops.
    public var range: CountableRange<Int> { return 0..<self }
    
    /// Returns number of digits in the integer.
    public var digits: Int {
        if self == 0 {
            return 1
        } else if Int(fabs(Double(self))) <= LONG_MAX {
            return Int(log10(fabs(Double(self)))) + 1
        } else {
            return -1; //out of bound
        }
    }
    
    /// The digits of an integer represented in an array(from most significant to least).
    /// This method ignores leading zeros and sign
    public var digitArray: [Int] {
        var digits = [Int]()
        for char in self.toString.characters {
            if let digit = Int(String(char)) {
                digits.append(digit)
            }
        }
        return digits
    }
    
    /// Returns a random integer number in the range min...max, inclusive.
    public static func random(within: Range<Int>) -> Int {
        let delta = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}
