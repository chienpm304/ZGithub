//
//  FetchPagingUserListUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

protocol FetchPagingUserListUseCase {
    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList
}

final class DefaultFetchPagingUserListUseCase: FetchPagingUserListUseCase {
    private let repository: UserListRepository

    init(repository: UserListRepository) {
        self.repository = repository
    }

    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList {
        try await repository.fetchUserList(
            pageSize: pageSize,
            offsetBy: fromUserID
        )
    }
}
