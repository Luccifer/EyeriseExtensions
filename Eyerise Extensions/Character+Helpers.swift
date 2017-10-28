//
//  Character+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension Character {
    /// Converts Character to String //TODO: Add to readme
    public var toString: String { return String(self) }
    
    /// If the character represents an integer that fits into an Int, returns the corresponding integer.
    public var toInt: Int? { return Int(String(self)) }
    
    /// Convert the character to lowercase
    public var lowercased: Character {
        let s = String(self).lowercased()
        return s[s.startIndex]
    }
    
    /// Convert the character to uppercase
    public var uppercased: Character {
        let s = String(self).uppercased()
        return s[s.startIndex]
    }
    
}
