//
//  TimeInterval+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension TimeInterval {
    func timeString() -> String {
        let seconds = Int(self) / 100
        return String(format:"%02i сек",seconds)
    }
}

