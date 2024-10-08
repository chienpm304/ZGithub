//
//  FetchUserDetailByUsernameUseCaseTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

import XCTest
@testable import ZGithub

final class FetchUserDetailByUsernameUseCaseTests: XCTestCase {
    enum TestError: Error {
        case fetch
        case emptyUsername
    }

    private var mockRepository: MockUserDetailRepository!
    private var useCase: DefaultFetchUserDetailByUsernameUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockUserDetailRepository()
        useCase = DefaultFetchUserDetailByUsernameUseCase(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        useCase = nil
        try super.tearDownWithError()
    }

    func test_execute_givenValidUsername_expectSuccess() async throws {
        // Given
        let expectedUserDetail = DMUserDetail(
            userID: 1,
            username: "username 1",
            name: "name 1",
            avatarURL: "avatar 1",
            blogURL: "blog 1",
            location: nil,
            followers: 100,
            following: 122
        )
        mockRepository.fetchUserDetailResult = .success(expectedUserDetail)

        // When
        let output = try await useCase.execute(username: "username 1")

        // Then
        XCTAssertEqual(output.userID, 1)
        XCTAssertEqual(output.username, "username 1")
        XCTAssertEqual(output.name, "name 1")
        XCTAssertEqual(output.avatarURL, "avatar 1")
        XCTAssertEqual(output.blogURL, "blog 1")
        XCTAssertEqual(output.location, nil)
        XCTAssertEqual(output.followers, 100)
        XCTAssertEqual(output.following, 122)

    }

    func test_execuute_givenInvalidUsername_expectError() async throws {
        // Given
        mockRepository.fetchUserDetailResult = .failure(TestError.fetch)

        do {
            // When
            _ = try await useCase.execute(username: "username")

            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as? TestError, .fetch)
        }
    }

    func test_execute_givenEmptyUsername_expectError() async throws {
        // Given
        mockRepository.fetchUserDetailResult = .failure(TestError.emptyUsername)

        do {
            // When
            _ = try await useCase.execute(username: "")

            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as? TestError, .emptyUsername)
        }
    }
}
