//
//  CacheManagableProtocol.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/9/21.
//

import Foundation

protocol CacheManagable {
    var cacheManager: URLCache { get set }
    func cachedResponse(for urlRequest: URLRequest) -> CachedURLResponse?
    func clearAllCache()
    func cacheConfig() -> URLSessionConfiguration
}
