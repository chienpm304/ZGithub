//
//  FetchUserDetailByUsernameUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

final class FetchUserDetailByUsernameUseCase: AsyncUseCase {
    struct Input {
        let username: String
    }
    typealias Output = DMUserDetail

    private let repository: UserDetailRepository

    init(repository: UserDetailRepository) {
        self.repository = repository
    }

    func execute(input: Input) async throws -> Output {
        try await repository.fetchUserDetail(username: input.username)
    }
}
