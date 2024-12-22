//
//  CacheManager.swift
//  i2048
//
//  Created by Rishi Singh on 22/12/24.
//

import Kingfisher

final class CacheManager {
    static let shared = CacheManager()
    
    private init() {
        configureCache()
    }
    
    private func configureCache() {
        let cache = ImageCache.default
        
        // Disk storage configuration
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 200 // 200 MB cache limit
        cache.diskStorage.config.expiration = .never // Cached images persist for 7 days
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 50 // 50 MB memory limit
        
        print("Kingfisher Cache Configured: 200MB Disk, 50MB Memory, No Expiration")
    }
    
    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            print("Kingfisher Cache Cleared")
        }
    }
}
