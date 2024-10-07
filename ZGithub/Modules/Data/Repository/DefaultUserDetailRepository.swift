//
//  DefaultUserDetailRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

final class DefaultUserDetailRepository {
    private let apiClient: APIProtocol
    private let userEndpointFactory: UserEndpointFactory
    private let userDetailStorage: UserDetailStorage

    init(
        apiClient: APIProtocol,
        userEndpointFactory: UserEndpointFactory,
        userDetailStorage: UserDetailStorage
    ) {
        self.apiClient = apiClient
        self.userEndpointFactory = userEndpointFactory
        self.userDetailStorage = userDetailStorage
    }
}

// MARK: UserRepository

extension DefaultUserDetailRepository: UserDetailRepository {
    func getCachedUserDetail(username: String) async throws -> DMUserDetail {
        try await userDetailStorage.fetchUserDetail(username: username)
    }

    func fetchUserDetail(username: String) async throws -> DMUserDetail {
        let endpoint = userEndpointFactory.makeUserDetailEndpoint(username: username)
        let userDetail: UserDetailResponse = try await apiClient.request(endpoint: endpoint)
        let userDetailDomain = userDetail.toDomain()
        try await userDetailStorage.saveUserDetail(userDetailDomain)
        return userDetailDomain
    }
}
