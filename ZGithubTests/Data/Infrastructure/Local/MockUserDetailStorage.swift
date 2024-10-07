//
//  MockUserDetailStorage.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

@testable import ZGithub

final class MockUserDetailStorage: UserDetailStorage {
    enum MockError: Error {
        case fetchNotSet
    }

    var fetchUserDetailResult: Result<DMUserDetail, Error>?
    var saveError: Error?

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

    func saveUserDetail(_ userDetail: DMUserDetail) async throws {
        if let error = saveError {
            throw error
        }
    }
}
