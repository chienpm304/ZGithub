//
//  AppConfiguration.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation
import Nuke

final class AppConfiguration {
    private let githubBaseURL = URL(string: "https://api.github.com")!
    
    lazy var githubAPIConfig = GithubAPIConfig(baseURL: githubBaseURL)

    lazy var imageCacheConfig = ImageCacheConfig.defaultConfig

    init() {
        setupAppConfiguration()
    }

    // MARK: Private

    private func setupAppConfiguration() {
        setupImageCaching()
    }

    // MARK: Image caching

    private func setupImageCaching() {
        ImageCache.shared.costLimit = imageCacheConfig.memoryLitmitInBytes
        ImageCache.shared.countLimit = imageCacheConfig.countLimit
        ImageCache.shared.ttl = imageCacheConfig.timeToLive
    }
}
