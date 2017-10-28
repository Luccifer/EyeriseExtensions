//
//  Collection+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension Collection {
    
    #if os(iOS)
    // A parralelized map for collections, operation is non blocking
    public func parallelizedMap<R>(_ each: @escaping (Self.Iterator.Element) -> R) -> [R?] {
        let indices = indicesArray()
        var res = [R?](repeating: nil, count: indices.count)
        
        let queue = OperationQueue()
        let operations = indices.enumerated().map { index in
            return BlockOperation {
                res[index.offset] = each(self[index.element])
            }
        }
        queue.addOperations(operations, waitUntilFinished: true)
        
        return res
    }
    
    /// Helper method to get an array of collection indices
    private func indicesArray() -> [Self.Index] {
        var indicesArray: [Self.Index] = []
        var nextIndex = startIndex
        while nextIndex != endIndex {
            indicesArray.append(nextIndex)
            nextIndex = index(after: nextIndex)
        }
        return indicesArray
    }
    #endif
}
