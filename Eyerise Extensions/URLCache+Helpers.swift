//
//  URLCache+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

/// Class extending standart URLCache functionality
open class EyrURLCache: URLCache {
    
    /// Ceche force expiration time
    open var cacheExpired: TimeInterval = 24.0 * 60.0 * 60.0
    
    /// Ignored content strings
    open var ignoredContent: [String] = []
    
    /// UserInfo expires key to save in local storage
    open static var ExpiresKey = "CNLURLCache"
    
    /// Get cache response for a request
    override open func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        
        // create empty response
        if let url = request.url?.absoluteString {
            if (ignoredContent.filter { return url.contains($0) }).count != 0 {
                return nil
            }
        }
        
        var response: CachedURLResponse? = nil
        
        // try to get cache response, userInfo and cache date
        if let cachedResponse = super.cachedResponse(for: request), let userInfo = cachedResponse.userInfo, let cacheDate = userInfo[EyrURLCache.ExpiresKey] as? Date {
            // check if the cache data are expired
            if cacheDate.timeIntervalSinceNow < -cacheExpired {
                // remove old cache request
                self.removeCachedResponse(for: request)
            } else {
                // the cache request is still valid
                response = cachedResponse
            }
        }
        
        return response
    }
    
    /// Store cached response
    override open func storeCachedResponse(_ cachedResponse: CachedURLResponse, for forRequest: URLRequest) {
        
        // create userInfo dictionary
        var userInfo = cachedResponse.userInfo ?? [:]
        
        // add current date to the UserInfo
        userInfo[EyrURLCache.ExpiresKey] = Date()
        
        // create new cached response
        let newCachedResponse = CachedURLResponse(
            response: cachedResponse.response,
            data: cachedResponse.data,
            userInfo: userInfo,
            storagePolicy: cachedResponse.storagePolicy
        )
        super.storeCachedResponse(newCachedResponse, for: forRequest)
    }
    
}
