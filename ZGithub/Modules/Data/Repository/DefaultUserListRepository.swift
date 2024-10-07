//
//  DefaultUserListRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class DefaultUserListRepository {
    private let apiClient: APIProtocol
    private let userEndpointFactory: UserEndpointFactory
    private let userListStorage: UserListStorage

    init(
        apiClient: APIProtocol,
        userEndpointFactory: UserEndpointFactory,
        userListStorage: UserListStorage
    ) {
        self.apiClient = apiClient
        self.userEndpointFactory = userEndpointFactory
        self.userListStorage = userListStorage
    }
}

// MARK: UserRepository

extension DefaultUserListRepository: UserListRepository {
    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        try await userListStorage.fetchUserList(pageSize: pageSize, offsetBy: userID)
    }

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        let endpoint = userEndpointFactory.makeUserListEndpoint(pageSize: pageSize, offsetID: userID)
        let userList: UserListResponse = try await apiClient.request(endpoint: endpoint)
        let userListDomain = userList.toDomain()
        try await userListStorage.saveUserList(userListDomain)
        return userListDomain
    }
}
