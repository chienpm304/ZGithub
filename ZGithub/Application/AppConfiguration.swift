//
//  AppConfiguration.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class AppConfiguration {
    private let githubBaseURL = URL(string: "https://api.github.com")!
    
    lazy var githubAPIConfig: GithubAPIConfig = GithubAPIConfig(baseURL: githubBaseURL)
}

struct GithubAPIConfig: APIConfig {
    let baseURL: URL
}
