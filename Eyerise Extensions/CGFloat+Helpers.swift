//
//  CGFloat+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension CGFloat {
        
        /// Return the central value of CGFloat.
        public var center: CGFloat { return (self / 2) }
        
        @available(*, deprecated: 1.8, renamed: "degreesToRadians")
        public func toRadians() -> CGFloat {
            return (.pi * self) / 180.0
        }
        
        /// Converts degrees to radians
        public func degreesToRadians() -> CGFloat {
            return (.pi * self) / 180.0
        }
        
        
        public mutating func toRadiansInPlace() {
            self = (.pi * self) / 180.0
        }
        
        /// Converts angle degrees to radians.
        public static func degreesToRadians(_ angle: CGFloat) -> CGFloat {
            return (.pi * angle) / 180.0
        }
        
        /// Converts radians to degrees.
        public func radiansToDegrees() -> CGFloat {
            return (180.0 * self) / .pi
        }
        
        /// Converts angle radians to degrees mutable version.
        public mutating func toDegreesInPlace() {
            self = (180.0 * self) / .pi
        }
        
        ///  Converts angle radians to degrees static version.
        public static func radiansToDegrees(_ angleInDegrees: CGFloat) -> CGFloat {
            return (180.0 * angleInDegrees) / .pi
        }
        
        /// Returns a random floating point number between 0.0 and 1.0, inclusive.
        public static func random() -> CGFloat {
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        
        /// Returns a random floating point number in the range min...max, inclusive.
        public static func random(within: Range<CGFloat>) -> CGFloat {
            return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
        }
        
        /// Returns a random floating point number in the range min...max, inclusive.
        public static func random(within: ClosedRange<CGFloat>) -> CGFloat {
            return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
        }
        
        /**
         Returns the shortest angle between two angles. The result is always between
         -π and π.
         */
        public static func shortestAngleInRadians(from first: CGFloat, to second: CGFloat) -> CGFloat {
            let twoPi = CGFloat(.pi * 2.0)
            var angle = (second - first).truncatingRemainder(dividingBy: twoPi)
            if angle >= .pi {
                angle -= twoPi
            }
            if angle <= -.pi {
                angle += twoPi
            }
            return angle
        }
    }
    
#endif
