//
//  DefaultUserDetailRepositoryTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

import XCTest
@testable import ZGithub

final class DefaultUserDetailRepositoryTests: XCTestCase {
    private enum TestError: Error {
        case someAPIError
        case someStorageError
    }
    private var mockApiClient: MockAPIClient!
    private var mockEndpointFactory: MockUserEndpointFactory!
    private var mockUserDetailStorage: MockUserDetailStorage!

    private var repository: DefaultUserDetailRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiClient = MockAPIClient()
        mockEndpointFactory = MockUserEndpointFactory()
        mockEndpointFactory.userListEndpointToken = "mock user list"
        mockEndpointFactory.userDetailEndpointToken = "mock user detail"
        mockUserDetailStorage = MockUserDetailStorage()
        repository = DefaultUserDetailRepository(
            apiClient: mockApiClient,
            userEndpointFactory: mockEndpointFactory,
            userDetailStorage: mockUserDetailStorage
        )
    }

    override func tearDownWithError() throws {
        mockApiClient = nil
        mockEndpointFactory = nil
        mockUserDetailStorage = nil
        repository = nil
        try super.tearDownWithError()
    }

    func test_getCachedUserDetail_givenValidUser_expectSuccess() async throws {
        // Given
        let expectedUserDetail = DMUserDetail(
            userID: 1,
            username: "username1",
            name: "name1",
            avatarURL: "avatar1",
            blogURL: "blog1",
            location: "location1",
            followers: 1,
            following: 2
        )
        mockUserDetailStorage.fetchUserDetailResult = .success(expectedUserDetail)

        // When
        let result = try await repository.getCachedUserDetail(username: "username1")

        // Then
        XCTAssertEqual(result.userID, 1)
        XCTAssertEqual(result.username, "username1")
        XCTAssertEqual(result.name, "name1")
        XCTAssertEqual(result.avatarURL, "avatar1")
        XCTAssertEqual(result.blogURL, "blog1")
        XCTAssertEqual(result.location, "location1")
        XCTAssertEqual(result.followers, 1)
        XCTAssertEqual(result.following, 2)
    }

    func test_getCachedUserDetail_givenUserNotFound_expectError() async throws {
        // Given
        mockUserDetailStorage.fetchUserDetailResult = .failure(TestError.someStorageError)

        do {
            // When
            _ = try await repository.getCachedUserDetail(username: "username")

            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as? TestError, .someStorageError)
        }
    }

    func test_fetchUserDetail_givenValidJSONInputWithAllFields_expectSuccess() async throws {
        // Given
        let jsonString = """
        {
          "login": "pjhyett",
          "id": 3,
          "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
          "html_url": "https://github.com/pjhyett",
          "name": "PJ Hyett",
          "blog": "https://hyett.com",
          "location": "San Francisco",
          "followers": 8307,
          "following": 30
        }
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)

        // When
        let result = try await repository.fetchUserDetail(username: "pjhyett")

        // Then
        XCTAssertEqual(result.userID, 3)
        XCTAssertEqual(result.username, "pjhyett")
        XCTAssertEqual(result.name, "PJ Hyett")
        XCTAssertEqual(result.avatarURL, "https://avatars.githubusercontent.com/u/3?v=4")
        XCTAssertEqual(result.blogURL, "https://github.com/pjhyett")
        XCTAssertEqual(result.location, "San Francisco")
        XCTAssertEqual(result.followers, 8307)
        XCTAssertEqual(result.following, 30)
    }

    func test_fetchUserDetail_givenValidJSONInputWithMinimalFields_expectSuccess() async throws {
        // Given
        let jsonString = """
        {
          "login": "pjhyett",
          "id": 3,
          "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
          "html_url": "https://github.com/pjhyett",
          "blog": "https://hyett.com"
        }
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)

        // When
        let result = try await repository.fetchUserDetail(username: "pjhyett")

        // Then
        XCTAssertEqual(result.userID, 3)
        XCTAssertEqual(result.username, "pjhyett")
        XCTAssertNil(result.name)
        XCTAssertEqual(result.avatarURL, "https://avatars.githubusercontent.com/u/3?v=4")
        XCTAssertEqual(result.blogURL, "https://github.com/pjhyett")
        XCTAssertNil(result.location)
        XCTAssertNil(result.followers)
        XCTAssertNil(result.following)
    }

    func test_fetchUserDetail_givenMissingJSONInputFields_expectDecodingError() async throws {
        // Given
        let jsonString = """
        {
          "login": "pjhyett",
          "id": 3,
        }
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)

        // When
        do {
            _ = try await repository.fetchUserDetail(username: "pjhyett")
            XCTFail("Expected error to be thrown")
        } catch {
            if case let APIError.decodingError(decodingError) = error {
                XCTAssertNotNil(decodingError)
            } else {
                XCTFail("Expected decodingError but got \(error)")
            }
        }
    }

    func test_fetchUserDetail_givenAPIError_expectError() async throws {
        // Given
        mockApiClient.result = .failure(TestError.someAPIError)

        // When / Then
        do {
            _ = try await repository.fetchUserDetail(username: "testUser")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someAPIError)
        }
    }

    func test_fetchUserDetail_givenValidJSONWithStorageSaveError_expectError() async throws {
        // Given
        let jsonString = """
        {
          "login": "pjhyett",
          "id": 3,
          "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
          "html_url": "https://github.com/pjhyett",
          "name": "PJ Hyett",
          "blog": "https://hyett.com",
          "location": "San Francisco",
          "followers": 8307,
          "following": 30
        }
        """
        let expectedData = jsonString.data(using: .utf8)!
        mockApiClient.result = .success(expectedData)
        mockUserDetailStorage.saveError = TestError.someStorageError

        // When / Then
        do {
            _ = try await repository.fetchUserDetail(username: "pjhyett")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someStorageError)
        }
    }

    func test_fetchUserDetail_givenBothAPIErrorAndStorageError_expectAPIError() async throws {
        // Given
        mockApiClient.result = .failure(TestError.someAPIError)
        mockUserDetailStorage.saveError = TestError.someStorageError

        // When / Then
        do {
            _ = try await repository.fetchUserDetail(username: "pjhyett")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .someAPIError)
        }
    }
}
