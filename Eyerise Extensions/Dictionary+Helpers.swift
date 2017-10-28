
//
//  Dictionary+helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

/// Common dictionary
public typealias EyrDictionary = [String: Any]

/// Array of CNLDictionary
public typealias EyrArray = [EyrDictionary]

/// Common dictionary key value
public protocol EyrDictionaryKey: Hashable { }
/// Common dictionary value
public protocol EyrDictionaryValue: Hashable { }

// MARK: - CNLDictionaryValue
extension Bool: EyrDictionaryValue { }
extension Int: EyrDictionaryValue { }
extension String: EyrDictionaryValue { }
extension Float: EyrDictionaryValue { }
extension Double: EyrDictionaryValue { }
extension String: EyrDictionaryKey { }

// MARK: - Extenstion for Dictionary for CNLDictionary purposes
public extension Dictionary {
    
    /// Get value for key with type check, returns default value when key doeas not exist either type check was failed
    ///
    /// - Parameters:
    ///   - name: Key value
    ///   - defaultValue: Default value
    /// - Returns: Value for the key (or defaultValue)
    public func value<T>(_ name: Key, _ defaultValue: T) -> T! where Key: EyrDictionaryKey, T: EyrDictionaryValue {
        let data = self[name]
        if let res = data as? T {
            return res
        }
        return defaultValue
    }
    
    /// Returns value for key with type check
    ///
    /// - Parameter name: Key value
    /// - Returns: Value for the key (or nil when type check was failed)
    public func value<T>(_ name: Key) -> T? where Key: EyrDictionaryKey, T: EyrDictionaryValue {
        return self[name] as? T
    }
    
    /// Calls closure with sub-dictionary for key with type check
    ///
    /// - Parameters:
    ///   - name: Key value for dictionary container
    ///   - closure: Closure to be called if type check successed
    public func dictionary(_ name: Key, closure: (_ data: Dictionary) -> Void) {
        if let possibleData = self[name] as? Dictionary {
            closure(possibleData)
        }
    }
    
    /// Calls closure for each element of the array in the dictionary array value
    ///
    /// - Parameters:
    ///   - name: Key value for the array container
    ///   - closure: Closure to be called if type check successed
    public func array<T>(_ name: Key, closure: (_ data: T) -> Void) where Key: EyrDictionaryKey {
        if let possibleData = self[name] as? [T] {
            for item in possibleData {
                closure(item)
            }
        }
    }
    
    /// Converts values of the key to an array
    ///
    /// - Parameter name: Key value
    /// - Returns: Result array
    public func array<T>(_ name: Key) -> [T] where Key: EyrDictionaryKey {
        return self[name] as? [T] ?? []
    }
    
    /// Special implementation `value<T>` function for Date class
    ///
    /// - Parameters:
    ///   - name: Key value
    ///   - defaultValue: Default value
    /// - Returns: Date struct with value of unix timestamp from the key, nil if type check was failed
    public func date(_ name: Key, _ defaultValue: Date? = nil) -> Date? {
        if let data = self[name] as? TimeInterval {
            return Date(timeIntervalSince1970: data)
        } else {
            return defaultValue
        }
    }
    
    /// Special implementation `value<T>` function for URL class
    ///
    /// - Parameters:
    ///   - name: Key value
    ///   - defaultValue: Default value
    /// - Returns: URL with string, nil if type check was failed
    public func url(_ name: Key, _ defaultValue: URL? = nil) -> URL? {
        if let data = self[name] as? String {
            return URL(string: data)
        } else {
            return defaultValue
        }
    }
    
    /// Maps dictionary values to the another dictionary with same keys, using transform closure for values
    ///
    /// - Parameter f: Transform closure
    /// - Returns: Dictionary with the same keys and transformed values
    public func map(_ transform: (Key, Value) -> Value) -> [Key:Value] {
        var ret = [Key: Value]()
        for (key, value) in self {
            ret[key] = transform(key, value)
        }
        return ret
    }
    
    /// Maps dictionary to the array, using transform function for values. It skips nil results
    ///
    /// - Parameter transform: Transform closure
    /// - Returns: Array with non-nil results of transform closure
    public func mapSkipNil<V>(_ transform: ((Key, Value)) -> V?) -> [V] {
        var result: [V] = []
        for item in self {
            if let entry = transform(item) {
                result.append(entry)
            }
        }
        
        return result
    }
    
    /// Maps dictionary to another dictionary
    ///
    /// - Parameter transform: Transform closure (it mapped source pair of key-value to result pair)
    /// - Returns: Dictionary with transformed pairs key-value from the source, exluding nil transform results
    public func mapSkipNil<K, V>(_ transform: ((Key, Value)) -> (K, V)?) -> [K: V] {
        var result: [K: V] = [:]
        for item in self {
            if let entry = transform(item) {
                result[entry.0] = entry.1
            }
        }
        
        return result
    }
    
    /// Filter the dictionary using closure
    ///
    /// - Parameter f: <#f description#>
    /// - Returns: <#return value description#>
    public func filter(_ check: (Key, Value) -> Bool) -> [Key:Value] {
        var result = [Key: Value]()
        for (key, value) in self {
            if check(key, value) {
                result[key] = value
            }
        }
        return result
    }
    
    /// Merge dictionary with another dictionary and returns result. When key values has intersections, values from the source dictionary will override existing values
    ///
    /// - Parameter with: Source dictionary
    /// - Returns: New dictionary with self and source elemenct
    public func merged(with source: [Key: Value]?) -> [Key: Value] {
        guard let source = source else { return self }
        var res = self
        res.merge(with: source)
        return res
    }
    
    /// Merge the dictionary with another dictionary. When key values has intersections, values from the source dictionary will override existing values
    ///
    /// - Parameter with: Source dictionary
    /// - Returns: New dictionary with self and source elemenct
    public mutating func merge(with source: [Key: Value]?) {
        guard let source = source else { return }
        for (key, value) in source {
            self[key] = value
        }
    }
    
    private func _check(_ list: EyrArray, _ path: String = "") {
        list.forEach { item in
            for (k, v) in item {
                if v is Bool || v is String || v is Int || v is Double || v is [Int] || v is [String] {
                    return
                }
                if let d = v as? EyrDictionary {
                    _check([d], "\(path).\(k)")
                    return
                }
                if let a = v as? EyrArray {
                    _check(a, "\(path).\(k)")
                    return
                }
                let t = type(of: v)
                fatalError("Invalid value: \(path)\(k) = \(v) of type \(t)")
            }
        }
    }
    
    /// Checks dictionary conformity NSDictionary.write(to:atomically). Calls fatalError() if not
    public func check() {
        if let dictionry = self as? EyrDictionary {
            _check([dictionry])
            return
        }
        fatalError("Check failed")
    }
    
    /// Stores plist representation of the dictionary to the url
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - atomically: <#atomically description#>
    public func write(to url: URL, atomically: Bool = true) {
        check()
        let dictionary = NSDictionary(dictionary: self)
        dictionary.write(to: url, atomically: atomically)
    }
    
    mutating func add(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

public extension Dictionary {
    
    /// Returns the value of a random Key-Value pair from the Dictionary
    public func random() -> Value? {
        return Array(values).random()
    }
    
    /// Union of self and the input dictionaries.
    public func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (arg) -> Void in
                
                let (key, value) = arg
                result[key] = value
            }
        }
        return result
    }
    
    /// Checks if a key exists in the dictionary.
    public func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// Creates an Array with values generated by running
    /// each [key: value] of self through the mapFunction.
    public func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    /// Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction.
    public func mapValues<V>(_ map: (Key, Value) -> V) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            mapped[$0] = map($0, $1)
        }
        return mapped
    }
    
    /// Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    public func mapFilterValues<V>(_ map: (Key, Value) -> V?) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[$0] = value
            }
        }
        return mapped
    }
    
    /// Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    public func mapFilter<K, V>(_ map: (Key, Value) -> (K, V)?) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        return mapped
    }
    
    /// Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction.
    public func map<K, V>(_ map: (Key, Value) -> (K, V)) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        }
        return mapped
    }
    
    /// Checks if test evaluates true for all the elements in self.
    public func testAll(_ test: (Key, Value) -> (Bool)) -> Bool {
        return !contains { !test($0, $1) }
    }
    
    /// Unserialize JSON string into Dictionary
    public static func constructFromJSON (json: String) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary {
            return data
        } else {
            return nil
        }
    }
    
    /// Serialize Dictionary into JSON string
    public func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
}

public extension Dictionary where Value: Equatable {
    /// Difference of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] pairs.
    public func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
}

/// Combines the first dictionary with the second and returns single dictionary
public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

/// Difference operator
public func - <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.difference(second)
}

