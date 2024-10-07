//
//  MockUserDetailRepository.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

import Foundation
@testable import ZGithub

final class MockUserDetailRepository: UserDetailRepository {
    private enum MockError: Error {
        case cacheNotSet
        case fetchNotSet
    }

    var cachedUserDetailResult: Result<DMUserDetail, Error>?
    var fetchUserDetailResult: Result<DMUserDetail, Error>?

    func getCachedUserDetail(username: String) async throws -> DMUserDetail {
        if let result = cachedUserDetailResult {
            switch result {
            case .success(let userDetail):
                return userDetail
            case .failure(let error):
                throw error
            }
        }
        throw MockError.cacheNotSet
    }

    func fetchUserDetail(username: String) async throws -> DMUserDetail {
        if let result = fetchUserDetailResult {
            switch result {
            case .success(let userDetail):
                return userDetail
            case .failure(let error):
                throw error
            }
        }
        throw MockError.fetchNotSet
    }
}
