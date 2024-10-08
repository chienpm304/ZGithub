//
//  MockUserListStorage.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//  
//

@testable import ZGithub

final class MockUserListStorage: UserListStorage {
    enum MockError: Error {
        case fetchNotSet
    }

    var fetchResult: Result<DMUserList, Error>?
    var saveError: Error?

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        if let result = fetchResult {
            switch result {
            case .success(let userList):
                return userList
            case .failure(let error):
                throw error
            }
        }
        throw MockError.fetchNotSet
    }

    func saveUserList(_ userList: DMUserList) async throws {
        if let error = saveError {
            throw error
        }
    }
}
