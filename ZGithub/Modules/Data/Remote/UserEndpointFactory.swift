//
//  UserEndpointFactory.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol UserEndpointFactory {
    func makeUserListEndpoint(pageSize: Int, offsetID: Int) -> APIEndpoint
    func makeUserDetailEndpoint(username: String) -> APIEndpoint
}

struct GithubUserEndpointFactory: UserEndpointFactory {
    private let config: APIConfig

    init(config: APIConfig) {
        self.config = config
    }

    func makeUserListEndpoint(pageSize: Int, offsetID: Int) -> APIEndpoint {
        let queryItems = [
            URLQueryItem(name: "per_page", value: String(pageSize)),
            URLQueryItem(name: "since", value: String(offsetID))
        ]
        return APIEndpoint(
            baseURL: config.baseURL,
            path: "/users",
            method: .get,
            queryItems: queryItems
        )
    }

    func makeUserDetailEndpoint(username: String) -> APIEndpoint {
        APIEndpoint(
            baseURL: config.baseURL,
            path: "/users/\(username)",
            method: .get
        )
    }
}
