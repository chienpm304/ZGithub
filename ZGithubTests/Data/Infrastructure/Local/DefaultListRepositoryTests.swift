//
//  DefaultListRepositoryTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//  
//

import XCTest
@testable import ZGithub

final class DefaultListRepositoryTests: XCTestCase {
    private enum TestError: Error {
        case someAPIError
        case someStorageError
    }
    private var mockApiClient: MockAPIClient!
    private var mockEndpointFactory: MockUserEndpointFactory!
    private var mockUserListStorage: MockUserListStorage!

    private var repository: DefaultUserListRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiClient = MockAPIClient()
        mockEndpointFactory = MockUserEndpointFactory()
        mockEndpointFactory.userListEndpointToken = "mock user list"
        mockEndpointFactory.userDetailEndpointToken = "mock user detail"
        mockUserListStorage = MockUserListStorage()
        repository = DefaultUserListRepository(
            apiClient: mockApiClient,
            userEndpointFactory: mockEndpointFactory,
            userListStorage: mockUserListStorage
        )
    }

    override func tearDownWithError() throws {
        mockApiClient = nil
        mockEndpointFactory = nil
        mockUserListStorage = nil
        repository = nil
        try super.tearDownWithError()
    }

    func test_getCachedUserList_givenValidUser_expectSuccess() async throws {
        // Given
        let expectedUser = DMUserBrief(
            userID: 1,
            username: "username1",
            avatarURL: "avatar1",
            blogURL: "blog1"
        )
        let expectedUserList = DMUserList(users: [expectedUser])
        mockUserListStorage.fetchResult = .success(expectedUserList)

        // When
        let result = try await repository.getCachedUserList(pageSize: 20, offsetBy: 0)

        // Then
        XCTAssertEqual(result.users.first?.userID, 1)
        XCTAssertEqual(result.users.first?.username, "username1")
        XCTAssertEqual(result.users.first?.avatarURL, "avatar1")
        XCTAssertEqual(result.users.first?.blogURL, "blog1")
    }

    func test_getCachedUserList_giveCacheError_expectError() async throws {
        // Given
        mockUserListStorage.fetchResult = .failure(TestError.someStorageError)

        do {
            // When
            _ = try await repository.getCachedUserList(pageSize: 20, offsetBy: 0)

            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as? TestError, .someStorageError)
        }
    }

    func test_fetchUserList_givenValidJSON_expectSuccess() async throws {
        // Given
        let jsonString = """
        [
          {
            "login": "defunkt",
            "id": 2,
            "avatar_url": "https://avatars.githubusercontent.com/u/2?v=4",
            "html_url": "https://github.com/defunkt"
          },
          {
            "login": "pjhyett",
            "id": 3,
            "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
            "html_url": "https://github.com/pjhyett"
          }
        ]
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)

        // When
        let result = try await repository.fetchUserList(pageSize: 20, offsetBy: 0)

        // Then
        XCTAssertEqual(result.users.count, 2)

        XCTAssertEqual(result.users[0].userID, 2)
        XCTAssertEqual(result.users[0].username, "defunkt")
        XCTAssertEqual(result.users[0].avatarURL, "https://avatars.githubusercontent.com/u/2?v=4")
        XCTAssertEqual(result.users[0].blogURL, "https://github.com/defunkt")

        XCTAssertEqual(result.users[1].userID, 3)
        XCTAssertEqual(result.users[1].username, "pjhyett")
        XCTAssertEqual(result.users[1].avatarURL, "https://avatars.githubusercontent.com/u/3?v=4")
        XCTAssertEqual(result.users[1].blogURL, "https://github.com/pjhyett")
    }

    func test_fetchUserList_givenMissingJSONInputFields_expectDecodingError() async throws {
        // Given
        let jsonString = """
        [
            {
              "login": "pjhyett",
              "id": 3,
            }
        ]
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)

        // When
        do {
            _ = try await repository.fetchUserList(pageSize: 20, offsetBy: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            if case let APIError.decodingError(decodingError) = error {
                XCTAssertNotNil(decodingError)
            } else {
                XCTFail("Expected decodingError but got \(error)")
            }
        }
    }

    func test_fetchUserList_givenAPIError_expectError() async throws {
        // Given
        mockApiClient.result = .failure(TestError.someAPIError)

        // When / Then
        do {
            _ = try await repository.fetchUserList(pageSize: 20, offsetBy: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someAPIError)
        }
    }

    func test_fetchUserList_givenValidJSONWithStorageSaveError_expectError() async throws {
        // Given
        let jsonString = """
        [
          {
            "login": "defunkt",
            "id": 2,
            "avatar_url": "https://avatars.githubusercontent.com/u/2?v=4",
            "html_url": "https://github.com/defunkt"
          },
          {
            "login": "pjhyett",
            "id": 3,
            "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
            "html_url": "https://github.com/pjhyett"
          }
        ]
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)
        mockUserListStorage.saveError = TestError.someStorageError

        // When / Then
        do {
            _ = try await repository.fetchUserList(pageSize: 20, offsetBy: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someStorageError)
        }
    }

    func test_fetchUserList_givenBothAPIErrorAndStorageError_expectAPIError() async throws {
        // Given
        mockApiClient.result = .failure(TestError.someAPIError)
        mockUserListStorage.saveError = TestError.someStorageError

        // When / Then
        do {
            _ = try await repository.fetchUserList(pageSize: 20, offsetBy: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someAPIError)
        }
    }
}
