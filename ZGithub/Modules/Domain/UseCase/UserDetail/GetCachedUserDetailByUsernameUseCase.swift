//
//  GetCachedUserDetailByUsernameUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class GetCachedUserDetailByUsernameUseCase: AsyncUseCase {
    struct Input {
        let username: String 
    }
    typealias Output = DMUserDetail

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(input: Input) async throws -> Output {
        try await repository.getCachedUserDetail(username: input.username)
    }
}
