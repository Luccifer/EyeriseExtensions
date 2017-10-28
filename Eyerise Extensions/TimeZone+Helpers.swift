//
//  TimeZone+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension TimeZone {
    
    /// - Returns: String with timezone of the date (ex: +0300, -0200, etc.)
    public static var localTimeZoneString: String {
        let seconds = NSTimeZone.local.secondsFromGMT()
        let minutes = abs(((seconds as Int) / 60) % 60)
        var minutesString = "\(minutes)"
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        let hours = abs(((seconds as Int) / 3600) % 24)
        var hoursString = "\(hours)"
        if hours < 10 {
            hoursString = "0" + hoursString
        }
        if seconds >= 0 {
            return "+\(hoursString)\(minutesString)"
        } else  {
            return "-\(hoursString)\(minutesString)"
        }
    }
}
