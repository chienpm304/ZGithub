//
//  GetCachedUserDetailByUsernameUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol GetCachedUserDetailByUsernameUseCase {
    func execute(username: String) async throws -> DMUserDetail
}

final class DefaultGetCachedUserDetailByUsernameUseCase: GetCachedUserDetailByUsernameUseCase {
    private let repository: UserDetailRepository

    init(repository: UserDetailRepository) {
        self.repository = repository
    }

    func execute(username: String) async throws -> DMUserDetail {
        try await repository.getCachedUserDetail(username: username)
    }
}
