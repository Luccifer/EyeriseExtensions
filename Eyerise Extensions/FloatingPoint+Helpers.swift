//
//  FloatingPoint+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension FloatingPoint {
    
    /// Returns rounded FloatingPoint to specified number of places
    public func rounded(toPlaces places: Int) -> Self {
        guard places >= 0 else { return self }
        var divisor: Self = 1
        for _ in 0..<places { divisor * 10 }
        return (self * divisor).rounded() / divisor
    }
    
    /// Rounds current FloatingPoint to specified number of places
    public mutating func round(toPlaces places: Int) {
        self = rounded(toPlaces: places)
    }
    
    /// Returns ceiled FloatingPoint to specified number of places
    public func ceiled(toPlaces places: Int) -> Self {
        guard places >= 0 else { return self }
        var divisor: Self = 1
        for _ in 0..<places { divisor * 10 }
        return (self * divisor).rounded(.up) / divisor
    }
    
    /// Ceils current FloatingPoint to specified number of places
    public mutating func ceil(toPlaces places: Int) {
        self = ceiled(toPlaces: places)
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Returns a random floating point number in the range min...max, inclusive.
    public static func random(within: Range<Float>) -> Float {
        return Float.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
}