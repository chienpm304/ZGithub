//
//  GetCachedUserDetailByUsernameUseCaseTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//
//

import XCTest
@testable import ZGithub

final class GetCachedUserDetailByUsernameUseCaseTests: XCTestCase {
    enum TestError: Error {
        case getCache
        case emptyUsername
    }

    private var repository: MockUserDetailRepository!
    private var useCase: GetCachedUserDetailByUsernameUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockUserDetailRepository()
        useCase = GetCachedUserDetailByUsernameUseCase(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
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
        repository.cachedUserDetailResult = .success(expectedUserDetail)

        // When
        let output = try await useCase.execute(input: .init(username: "username 1"))

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
        repository.cachedUserDetailResult = .failure(TestError.getCache)

        // When & Then
        do {
            _ = try await useCase.execute(input: .init(username: "username"))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .getCache)
        }
    }

    func test_execute_givenEmptyUsername_expectError() async throws {
        // Given
        repository.cachedUserDetailResult = .failure(TestError.emptyUsername)

        // When
        let input = GetCachedUserDetailByUsernameUseCase.Input(username: "")

        // Then
        do {
            _ = try await useCase.execute(input: input)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .emptyUsername)
        }
    }
}
