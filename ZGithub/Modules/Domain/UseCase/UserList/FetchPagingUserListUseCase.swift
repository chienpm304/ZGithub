//
//  FetchPagingUserListUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

final class FetchPagingUserListUseCase: AsyncUseCase {
    struct Input {
        let pageSize: Int
        let fromUserID: UserID
    }
    typealias Output = DMUserList

    private let repository: UserListRepository

    init(repository: UserListRepository) {
        self.repository = repository
    }

    func execute(input: Input) async throws -> Output {
        try await repository.fetchUserList(
            pageSize: input.pageSize,
            offsetBy: input.fromUserID
        )
    }
}
