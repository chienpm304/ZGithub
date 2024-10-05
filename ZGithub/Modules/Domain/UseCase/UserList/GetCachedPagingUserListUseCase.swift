//
//  GetCachedPagingUserListUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class GetCachedPagingUserListUseCase: AsyncUseCase {
    struct Input {
        let pageSize: Int
        let fromUserID: UserID
    }
    typealias Output = DMUserList

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(input: Input) async throws -> Output {
        try await repository.getCachedUserList(
            pageSize: input.pageSize,
            offsetBy: input.fromUserID
        )
    }
}
