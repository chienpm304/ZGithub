//
//  MockUserListRepository.swift
//  ZGithubTests
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation
@testable import ZGithub

final class MockUserListRepository: UserListRepository {
    private enum MockError: Error {
        case cacheNotSet
        case fetchNotSet
    }

    var cachedUserListResult: Result<DMUserList, Error>?
    var fetchUserListResult: Result<DMUserList, Error>?

    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        if let result = cachedUserListResult {
            switch result {
            case .success(let userList):
                return userList
            case .failure(let error):
                throw error
            }
        }
        throw MockError.cacheNotSet
    }

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        if let result = fetchUserListResult {
            switch result {
            case .success(let userList):
                return userList
            case .failure(let error):
                throw error
            }
        }
        throw MockError.fetchNotSet
    }
}
