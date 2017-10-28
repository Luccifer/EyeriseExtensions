//
//  Bool+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

extension Bool {
    /// Converts Bool to Int.
    public var toInt: Int { return self ? 1 : 0 }
    
    /// Toggle boolean value.
    @discardableResult
    public mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
    /// Return inverted value of bool.
    public var toggled: Bool {
        return !self
    }
}
