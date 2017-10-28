//
//  String+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

import Foundation

public extension String {
    
    /// encode String and converts it to Data format using UTF-8
    ///
    func encodeStringData() -> Data {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    /// Returns russian standart of phonetic metrics for minutes of given Int minutes value
    ///
    /// - Parameter number: minutes you want to use
    /// - Returns: String as minute(s) in Russian phonetic standart
    static func toMinutes(_ number: Int) -> String {
        switch number {
        case 1, 21, 31, 41, 51:
            return "минуту"
        case 5...20, 25...30, 35...40, 45...50, 55:
            return "минут"
        default:
            return "минуты"
        }
    }
    
    /// Returns russian standart of phonetic metrics for hours of given Int hours value
    ///
    /// - Parameter number: hours you want to use
    /// - Returns: String as hour(s) in Russian phonetic standart
    static func toHours(_ number: Int) -> String {
        switch number {
        case 1, 21:
            return "час"
        case 5...20:
            return "часов"
        default:
            return "часа"
        }
    }
    
    /// Returns russian standart of phonetic metrics for days of given Int minutes value
    ///
    /// - Parameter number: days you want to use
    /// - Returns: String as day(s) in Russian phonetic standart
    static func toDays(_ number: Int) -> String {
        switch number {
        case 1:
            return "день"
        default:
            return "дня"
        }
    }
    
    /// Length of string (characters count)
    public var length: Int {
        return Array(self.characters).count
    }
    
    /// Character by index
    ///
    /// - Parameter i: index
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    /// Character as String by index
    ///
    /// - Parameter i: index
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    /// Substring with Range
    ///
    /// - Parameter r: range of indexes
    public subscript (r: CountableRange<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    /// Substring with Closed Range
    ///
    /// - Parameter r: range of indexes
    public subscript (r: CountableClosedRange<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound + 1)
        return String(self[Range(start ..< end)])
    }
    
    /// Converts string to Double?
    public var toDouble: Double? {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        return nf.number(from: self)?.doubleValue
    }
    
    /// Converts string to Int?
    public var toInt: Int? {
        if let double = toDouble {
            return Int(double)
        } else {
            return nil
        }
    }
    
    /// Inserts substring in file or url path before extension (last "." character)
    ///
    /// - Parameter suffix: substring to insert
    /// - Returns: modified string
    public func appendSuffixBeforeExtension(_ suffix: String) -> String {
        let regex = try? NSRegularExpression(pattern: "(\\.\\w+$)", options: [])
        return regex!.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.length), withTemplate: "\(suffix)$1")
    }
    
    /*
     /// Returns MD5 hash value of the string
     public var md5: String {
     let str = self.cString(using: String.Encoding.utf8)
     let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
     let digestLen = Int(CC_MD5_DIGEST_LENGTH)
     let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
     
     CC_MD5(str!, strLen, result)
     var hash = ""
     for i in 0..<digestLen {
     hash += String(format: "%02x", result[i])
     }
     
     result.deallocate(capacity: digestLen)
     
     return String(format: hash as String)
     }
     */
    
    /// Return truncated string by specified length, and append trailing stirng (if any)
    ///
    /// - Parameters:
    ///   - length: max length for truncation
    ///   - trailing: trailing appendix
    /// - Returns: Result string
    public func truncate(_ length: Int, trailing: String? = nil) -> String {
        if self.length > length {
            #if swift(>=4.0)
                let to = self.characters.index(self.startIndex, offsetBy: length)
                return String(self[..<to]) + (trailing ?? "")
            #else
                return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
            #endif
        } else {
            return self
        }
    }
    
    /// Checks is string contans a valid e-mail address
    public var isEmail: Bool {
        if self != "" {
            let mask = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", mask)
            return emailTest.evaluate(with: self)
        }
        return false
    }
    
    fileprivate func _applyFormat(_ format: String, placeholderChar placeholder: Character) -> (data: String, isCompleted: Bool) {
        var result: String = ""
        var dataIndex = startIndex
        var formatIndex = format.startIndex
        while (dataIndex < endIndex) && (formatIndex < format.endIndex) {
            let fCh = format.characters[formatIndex]
            if fCh == placeholder {
                result.append(characters[dataIndex])
                dataIndex = index(after: dataIndex)
                formatIndex = format.index(after: formatIndex)
            } else {
                result.append(fCh)
                formatIndex = format.index(after: formatIndex)
            }
        }
        return (
            data: result,
            isCompleted: (dataIndex == endIndex) && (formatIndex == format.endIndex)
        )
    }
    
    /// Applies specified format to string
    ///
    /// - Parameters:
    ///   - format: Format string
    ///   - placeholder: Placeholder character used in format string
    /// - Returns: Formatted string
    public func applyFormat(_ format: String, placeholderChar placeholder: Character = "#") -> String {
        return _applyFormat(format, placeholderChar: placeholder).data
    }
    
    /// Checks string for completly applying specified format
    ///
    /// - Parameters:
    ///   - format: Format string
    ///   - placeholder: Placeholder character used in format string
    /// - Returns: Result of check
    public func checkFormat(_ format: String, placeholderChar placeholder: Character = "#") -> Bool {
        return _applyFormat(format, placeholderChar: placeholder).isCompleted
    }
    
    /// Extracts digits from the string
    public var digitsOnly: String {
        let nonDigits = CharacterSet.decimalDigits.inverted
        return components(separatedBy: nonDigits).joined(separator: "")
    }
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    /// Returns Boolean value if String contain only one emoji and only
    ///
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    /// Returns Boolean value if String has any emoji symbol
    ///
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    /// Returns if String consists only of emojis
    ///
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    /// Returns Array value of String(s) with emojies in particular given String
    ///
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}


#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS)
    import UIKit
#endif

extension String {
    /// Init string with a base64 encoded string
    init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }
    
    /// base64 encoded of string
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    /// Cut string from range
    public subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    /// Cut string from closedrange
    public subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }
    
    /// Counts number of instances of the input inside String
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// Counts whitespace & new lines
    @available(*, deprecated: 1.6, renamed: "isBlank")
    public func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines
        let newText = self.trimmingCharacters(in: characterSet)
        return newText.isEmpty
    }
    
    /// Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Position of begining character of substing
    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    /// split string using a spearator string, returns an array of string
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// split string with delimiters, returns an array of string
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// Returns count of words in string
    public var countofWords: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
        return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
    }
    
    /// Returns count of paragraphs in string
    public var countofParagraphs: Int {
        let regex = try? NSRegularExpression(pattern: "\\n", options: NSRegularExpression.Options())
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (regex?.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(), range: NSRange(location:0, length: str.length)) ?? -1) + 1
    }
    
    /// Returns if String is a number
    public func isNumber() -> Bool {
        if NumberFormatter().number(from: self) != nil {
            return true
        }
        return false
    }
    
    /// Extracts URLS from String
    public var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }
        
        let text = self
        
        if let detector = detector {
            detector.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count), using: {(result: NSTextCheckingResult?, _, _) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }
        
        return urls
    }
    
    /// Checking if String contains input with comparing options
    public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    /// Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    /// Returns the first index of the occurency of the character in String
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in characters.enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// Converts String to NSString
    public var toNSString: NSString { return self as NSString }
    
    #if os(iOS)
    
    /// Returns bold NSAttributedString
    public func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        return boldString
    }
    
    #endif
    
    /// Returns underlined NSAttributedString
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return underlineString
    }
    
    #if os(iOS)
    
    /// Returns italic NSAttributedString
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)
    
    ///EZSE: Returns NSAttributedString
    public func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor: color])
        return colorString
    }
    
    /// Returns NSAttributedString
    public func colorSubString(_ subString: String, color: UIColor) -> NSMutableAttributedString {
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString, options: NSString.CompareOptions.literal, range: NSRange(location: start, length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
        return attrText
    }
    
    #endif
    
    /// Checks if String contains Emoji
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    #if os(iOS)
    
    /// copy string to pasteboard
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    #endif
    
    // URL encode a string (percent encoding special chars)
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    // URL encode a string (percent encoding special chars) mutating version
    mutating func urlEncode() {
        self = urlEncoded()
    }
    
    // Removes percent encoding from string
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    
    // Mutating versin of urlDecoded
    mutating func urlDecode() {
        self = urlDecoded()
    }
}

public extension String {
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}

/// Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

/// Can be used in switch-case
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

/// Can be used in switch-case
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}
