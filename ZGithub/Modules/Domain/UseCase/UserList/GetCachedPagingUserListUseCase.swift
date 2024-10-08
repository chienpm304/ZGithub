//
//  GetCachedPagingUserListUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//
//

import Foundation

protocol GetCachedPagingUserListUseCase {
    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList
}

final class DefaultGetCachedPagingUserListUseCase: GetCachedPagingUserListUseCase {
    private let repository: UserListRepository

    init(repository: UserListRepository) {
        self.repository = repository
    }

    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList {
        try await repository.getCachedUserList(pageSize: pageSize, offsetBy: fromUserID)
    }
}
