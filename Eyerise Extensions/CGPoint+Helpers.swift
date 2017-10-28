//
//  CGPoint+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public enum ScrollDirection {
    case up
    case down
}

public extension CGPoint {
    
    public func isNegative() -> ScrollDirection {
        if self.y < 0.0  {
            return .down
        }else{
            return .up
        }
    }
    
}


#if os(iOS) || os(tvOS)
    
    extension CGPoint {
        
        /// Constructor from CGVector
        public init(vector: CGVector) {
            self.init(x: vector.dx, y: vector.dy)
        }
        
        /// Constructor from CGFloat
        public init(angle: CGFloat) {
            self.init(x: cos(angle), y: sin(angle))
        }
        
        /// Adds two CGPoints.
        public static func + (this: CGPoint, that: CGPoint) -> CGPoint {
            return CGPoint(x: this.x + that.x, y: this.y + that.y)
        }
        
        /// Subtracts two CGPoints.
        public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
            return CGPoint(x: left.x - right.x, y: left.y - right.y)
        }
        
        /// Multiplies a CGPoint with a scalar CGFloat.
        public static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
            return CGPoint(x: point.x * scalar, y: point.y * scalar)
        }
        
        /// Calculates the distance between two CG Points.
        public static func distance(from: CGPoint, to: CGPoint) -> CGFloat {
            return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
        }
        
        /// Normalizes the vector described by the CGPoint to length 1.0 and returns the result as a new CGPoint.
        public func normalized() -> CGPoint {
            let len = CGPoint.distance(from: self, to: CGPoint.zero)
            return CGPoint(x: self.x / len, y: self.y / len)
        }
        
        //// Returns the angle represented by the point.
        public var angle: CGFloat {
            return atan2(y, x)
        }
        
        //// Returns the dot product of two vectors represented by points
        public static func dotProduct(this: CGPoint, that: CGPoint) -> CGFloat {
            return this.x * that.x + this.y * that.y
        }
        
        ///  Performs a linear interpolation between two CGPoint values.
        public static func linearInterpolation(startPoint: CGPoint, endPoint: CGPoint, interpolationParam: CGFloat) -> CGPoint {
            return startPoint + (endPoint - startPoint) * interpolationParam
        }
    }
    
#endif
