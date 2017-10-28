//
//  GCD+Extensions.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

/// Run сlosure after particular time period
///
/// - Parameters:
///   - seconds: time in double format
///   - after: closure which will be executed after
public func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
    runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
}

fileprivate func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
    let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: time, execute: after)
}

/// Run сlosure in the main thread, usefull for UI changes
///
/// - Parameters:
///   - block: closure to be executed in Main thread, enshure exit from retain circles
public func runThisInMainThread(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

/// Run сlosure in the background thread, usefull for long time period tasks
///
/// - Parameters:
///   - block: closure to be executed in Background thread, enshure exit from retain circles
public func runThisInBackground(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

/// Run сlosure every particular time after the time period
///
/// - Parameters:
///   - seconds: code will be executed every this double format value of time
///   - startAfterSeconds: code will be executed in loop after this time period in double format
///   - handler: closure to be executed in Background thread, enshure exit from retain circles
public  func runThisEvery(seconds: TimeInterval, startAfterSeconds: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
    let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    return timer!
}

/// Run backgoundClosure async in global queue, then completionClosure async in main queue
///
/// - Parameters:
///   - backgroundClosure: payload closure
///   - completionClosure: completion closure
public func asyncGlobal (_ backgroundClosure: @escaping () -> Void, _ completionClosure: @escaping (() -> Void) ) {
    DispatchQueue.global(qos: .default).async {
        backgroundClosure()
        DispatchQueue.main.async {
            completionClosure()
        }
    }
}

/// Run backgoundClosure async in global queue
///
/// - Parameters:
///   - backgroundClosure: payload closure
public func asyncGlobal (_ backgroundClosure: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async {
        backgroundClosure()
    }
}

/// Run backgoundClosure async in global queue, then calls completionClosure async in main queue with result of backgroundClosure
///
/// - Parameters:
///   - backgroundClosure: payload closure with result
///   - completionClosure: completion closure with parameter
public func asyncGlobal<R> (_ backgroundClosure: @escaping () -> R, _ completionClosure: @escaping ((_ result: R) -> Void) ) {
    DispatchQueue.global(qos: .default).async {
        let res = backgroundClosure()
        DispatchQueue.main.async {
            completionClosure(res)
        }
    }
}

/// Run backgoundClosure sync in main queue
///
/// - Parameter backgroundClosure: <#backgroundClosure description#>
public func syncMain (_ backgroundClosure: @escaping () -> Void ) {
    DispatchQueue.main.sync {
        backgroundClosure()
    }
}

/// Run backgoundClosure async in main queue, then calls completionClosure
///
/// - Parameters:
///   - backgroundClosure: payload closure
///   - completionClosure: completion closure
public func asyncMain (_ backgroundClosure: @escaping () -> Void, _ completionClosure: @escaping (() -> Void) ) {
    DispatchQueue.main.async {
        backgroundClosure()
        completionClosure()
    }
}

/// Run backgoundClosure async in main queue
///
/// - Parameters:
///   - backgroundClosure: payload closure
public func asyncMain (_ backgroundClosure: @escaping () -> Void ) {
    DispatchQueue.main.async {
        backgroundClosure()
    }
}

/// Run backgoundClosure async in main queue, then calls completionClosure with result of backgroundClosure
///
/// - Parameters:
///   - backgroundClosure: payload closure with result
///   - completionClosure: completion closure with parameter
public func asyncMain<R> (_ backgroundClosure: @escaping () -> R, _ completionClosure: @escaping ((_ result: R) -> Void) ) {
    DispatchQueue.main.async {
        let res = backgroundClosure()
        completionClosure(res)
    }
}

/// Brackets call of closure in objc_sync_enter and objc_sync_exit calls, assotiated with object
///
/// - Parameters:
///   - object: Object used as lock souorce
///   - closure: Closure to execute while lock is active
@inline(__always)
public func syncCritical(_ object: Any, _ closure: () -> Void) {
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

precedencegroup CNFTWith {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator -->: CNFTWith

/// Executes right part with left part as an argument, returns retult of execution (not Optional)
///
/// - Parameters:
///   - left: Source value
///   - right: Closue to execute
/// - Returns: Result of left closure
@inline(__always)
@discardableResult
public func --> <T, U>(left: T, right: (T) -> U) -> U {
    return right(left)
}

/// Executes right part with left part as an argument, returns retult of execution (Optional)
///
/// - Parameters:
///   - left: Source value
///   - right: Closue to execute
/// - Returns: Result of left closure
@inline(__always)
@discardableResult
public func --> <T, U>(left: T?, right: (T?) -> U?) -> U? {
    return right(left)
}

/// Executes right part with left part as an argument, returns left part (not Optional)
///
/// - Parameters:
///   - left: Source value
///   - right: Closue to execute
/// - Returns: Result of left closure
@inline(__always)
@discardableResult
public func --> <T>(left: T, right: (T) -> Void) -> T {
    right(left)
    return left
}

/// Executes right part with left part as an argument, returns left part (Optional)
///
/// - Parameters:
///   - left: Source value
///   - right: Closue to execute
/// - Returns: Result of left closure
@inline(__always)
@discardableResult
public func --> <T>(left: T?, right: (T?) -> Void) -> T? {
    right(left)
    return left
}
