//
//  MockUserEndpointFactory.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//  
//

import Foundation
@testable import ZGithub

final class MockUserEndpointFactory: UserEndpointFactory {
    private let baseURL = URL(string: "mockBaseURL")!
    var userDetailEndpointToken: String!
    var userListEndpointToken: String!

    func makeUserDetailEndpoint(username: String) -> APIEndpoint {
        APIEndpoint(
            baseURL: baseURL,
            path: userDetailEndpointToken,
            method: .get,
            queryItems: nil
        )
    }

    func makeUserListEndpoint(pageSize: Int, offsetID: UserID) -> APIEndpoint {
        APIEndpoint(
            baseURL: baseURL,
            path: userListEndpointToken,
            method: .get,
            queryItems: nil
        )
    }
}
