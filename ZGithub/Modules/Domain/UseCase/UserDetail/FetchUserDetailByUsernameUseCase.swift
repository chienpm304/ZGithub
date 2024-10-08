//
//  FetchUserDetailByUsernameUseCase.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

protocol FetchUserDetailByUsernameUseCase {
    func execute(username: String) async throws -> DMUserDetail
}

final class DefaultFetchUserDetailByUsernameUseCase: FetchUserDetailByUsernameUseCase {
    private let repository: UserDetailRepository

    init(repository: UserDetailRepository) {
        self.repository = repository
    }

    func execute(username: String) async throws -> DMUserDetail {
        try await repository.fetchUserDetail(username: username)
    }
}
