//
//  AssociatedObjects.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

func associatedObject<ValueType>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {
        return associated
    }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

open class Associated<T>: NSObject, NSCopying {
    
    open var closure: T?
    
    /// Default initializer with closure
    ///
    /// - Parameter value: Value
    public convenience init(closure: T?) {
        self.init()
        self.closure = closure
    }
    
    /// Default copy function
    ///
    /// - Parameter zone: Zone
    /// - Returns: Copied instance
    @objc open func copy(with zone: NSZone?) -> Any {
        let wrapper: Associated<T> = Associated<T>()
        wrapper.closure = closure
        return wrapper
    }
    
}
