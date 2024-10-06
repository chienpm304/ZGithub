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

extension DefaultUserListRepository: UserListRepository {
    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        try await userStorage.fetchUserList(pageSize: pageSize, offsetBy: userID)
    }

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        let endpoint = userEndpointFactory.makeUserListEndpoint(pageSize: pageSize, offsetID: userID)
        let userList: UserListResponse = try await apiClient.request(endpoint: endpoint)
        let userListDomain = userList.toDomain()
        try await userStorage.saveUserList(userListDomain)
        return userListDomain
    }
}
