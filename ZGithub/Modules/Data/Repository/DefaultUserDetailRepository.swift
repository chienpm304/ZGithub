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
    private let userStorage: UserStorage

    init(
        apiClient: APIProtocol,
        userEndpointFactory: UserEndpointFactory,
        userStorage: UserStorage
    ) {
        self.apiClient = apiClient
        self.userEndpointFactory = userEndpointFactory
        self.userStorage = userStorage
    }
}

// MARK: UserRepository

extension DefaultUserDetailRepository: UserDetailRepository {
    func getCachedUserDetail(username: String) async throws -> DMUserDetail {
        try await userStorage.fetchUserDetail(username: username)
    }

    func fetchUserDetail(username: String) async throws -> DMUserDetail {
        let endpoint = userEndpointFactory.makeUserDetailEndpoint(username: username)
        let userDetail: UserDetailResponse = try await apiClient.request(endpoint: endpoint)
        let userDetailDomain = userDetail.toDomain()
        try await userStorage.saveUserDetail(userDetailDomain)
        return userDetailDomain
    }
}
