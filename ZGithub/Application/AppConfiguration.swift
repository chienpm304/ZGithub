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
    
    lazy var githubAPIConfig: GithubAPIConfig = GithubAPIConfig(baseURL: githubBaseURL)

    init() {
        setupAppConfiguration()
    }

    private func setupAppConfiguration() {
        setupIamgeCaching()
    }

    // MARK: Image caching

    private func setupIamgeCaching() {
        ImageCache.shared.costLimit = 1024 * 1024 * 200 // 200 MB
        ImageCache.shared.countLimit = 1000
        ImageCache.shared.ttl = 120 // Invalidate image after 120 sec
    }
}

struct GithubAPIConfig: APIConfig {
    let baseURL: URL
}
