//
//  DefaultUserRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class DefaultUserRepository {
    private let apiClient: APIProtocol
    private let userEndpointFactory: UserEndpointFactory
    private let storage: UserStorage

    init(
        apiClient: APIProtocol,
        userEndpointFactory: UserEndpointFactory,
        storage: UserStorage
    ) {
        self.apiClient = apiClient
        self.userEndpointFactory = userEndpointFactory
        self.storage = storage
    }
}

// MARK: UserRepository

extension DefaultUserRepository: UserRepository {
    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        try await storage.fetchUserList(pageSize: pageSize, offsetBy: userID)
    }

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        let endpoint = userEndpointFactory.makeUserListEndpoint(pageSize: pageSize, offsetID: userID)
        let userList: UserListResponse = try await apiClient.request(endpoint: endpoint)
        let userListDomain = userList.toDomain()
        try await storage.saveUserList(userListDomain)
        return userListDomain
    }

    func getCachedUserDetail(username: String) async throws -> DMUserDetail? {
        try await storage.fetchUserDetail(username: username)
    }

    func fetchUserDetail(username: String) async throws -> DMUserDetail {
        let endpoint = userEndpointFactory.makeUserDetailEndpoint(username: username)
        let userDetail: UserDetailResponse = try await apiClient.request(endpoint: endpoint)
        let userDetailDomain = userDetail.toDomain()
        try await storage.saveUserDetail(userDetailDomain)
        return userDetailDomain
    }
}
