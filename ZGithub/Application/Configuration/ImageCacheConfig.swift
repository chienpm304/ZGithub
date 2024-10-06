//
//  ImageCacheConfig.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

struct ImageCacheConfig {
    let memoryLitmitInBytes: Int
    let countLimit: Int
    let timeToLive: TimeInterval?
}

extension ImageCacheConfig {
    static let defaultConfig = ImageCacheConfig(
        memoryLitmitInBytes: 1024 * 1024 * 512, // 512 MB,
        countLimit: 2000,
        timeToLive: nil // never expired
    )
}
