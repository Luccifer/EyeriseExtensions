//
//  Logging.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

/// Level of logging
/// - debug: Debug level
/// - network: Network level
/// - info: Information level
/// - warning: Warning level
/// - error: Error level
/// - nolog: Disable logging
public enum EyrLogLevel: Int {
    /// Debug level
    case debug
    /// Network level
    case network
    /// Information level
    case info
    /// Warning level
    case warning
    /// Error level
    case error
    /// Disable logging
    case nolog
    
    /// Array of all possible value
    public static let allValues: [EyrLogLevel] = [debug, network, info, warning, error, nolog]
    
    /// Icon string
    public var icon: String {
        switch self {
        case .debug: return "➡️"
        case .network: return "🌐"
        case .info: return "💡"
        case .warning: return "❗"
        case .error: return "❌"
        case .nolog: return ""
        }
    }
}

/// Pretty logger to the debug console
public struct EyrLogger {
    
    public static var prefix: String = "CNL"
    
    public struct Message {
        public var code: String
        public var message: String
        
        public init(code: String, message: String) {
            self.code = code
            self.message = message
        }
        
        fileprivate func formatLogMessage(kind: String? = nil, _ params: [CVarArg]) -> String {
            let formattedMessage = String(format: self.message, arguments: params)
            if let kind = kind {
                return "[\(EyrLogger.prefix)] \(kind) [\(code)] \(formattedMessage)"
            } else {
                return "[\(EyrLogger.prefix)] [\(code)] \(formattedMessage)"
            }
        }
        
        fileprivate func formatLogMessage(kind: String? = nil) -> String {
            if let kind = kind {
                return "[\(EyrLogger.prefix)] \(kind) [\(code)] \(message)"
            } else {
                return "[\(EyrLogger.prefix)] [\(code)] \(message)"
            }
        }
    }
    
    public static var level: EyrLogLevel = .debug
    
    /// Log message to console with specified level
    ///
    /// - Parameters:
    ///   - message: Message to log
    ///   - level: Log level
    public static func log(_ message: CustomStringConvertible, level: EyrLogLevel) {
        if EyrLogger.level.rawValue <= level.rawValue && level != .nolog {
            print("\(level.icon) \(message)")
        }
    }
    
    /// Log messages to console with specified level
    ///
    /// - Parameters:
    ///   - messages: Array of messages to log
    ///   - level: Log level
    ///   - separator: Optional separator string
    public static func log(_ messages: [CustomStringConvertible], level: EyrLogLevel, separator: String? = nil) {
        if EyrLogger.level.rawValue <= level.rawValue && level != .nolog {
            let combinedMessage = messages.map { return $0.description }.joined(separator: separator ?? "")
            print("\(level.icon) \(combinedMessage)")
        }
    }
    
}

public func cnlLog(_ code: EyrLogger.Message, _ level: EyrLogLevel = .debug, _ params: CVarArg ...) {
    EyrLogger.log(code.formatLogMessage(params), level: level)
}

public func cnlLog(_ code: EyrLogger.Message, _ level: EyrLogLevel = .debug) {
    EyrLogger.log(code.formatLogMessage(), level: level)
}

public func cnlFatalError(_ code: EyrLogger.Message, _ params: CVarArg ...) -> Never  {
    fatalError(code.formatLogMessage(kind: "[FATAL ERROR]", params))
}

public func cnlFatalError(_ code: EyrLogger.Message) -> Never  {
    fatalError(code.formatLogMessage(kind: "[FATAL ERROR]"))
}

public func assert(_ condition: Bool, _ code: EyrLogger.Message, _ params: CVarArg ...) {
    assert(condition, code.formatLogMessage(kind: "[ASSERT]", params))
}

public func assert(_ condition: Bool, _ code: EyrLogger.Message) {
    assert(condition, code.formatLogMessage(kind: "[ASSERT]"))
}
