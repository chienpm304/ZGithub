//
//  FetchPagingUserListUseCaseTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 7/10/24.
//  
//

import XCTest
@testable import ZGithub

final class FetchPagingUserListUseCaseTests: XCTestCase {
    enum TestError: Error {
        case fetch
    }

    private var repository: MockUserListRepository!
    private var useCase: FetchPagingUserListUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockUserListRepository()
        useCase = FetchPagingUserListUseCase(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        useCase = nil
        try super.tearDownWithError()
    }

    func test_execute_givenSingleUser_expectSuccess() async throws {
        // Given
        let expectedUser = DMUserBrief(userID: 1, username: "username1", avatarURL: "avatar1", blogURL: "blog1")
        let expectedUserList = DMUserList(users: [expectedUser])
        repository.fetchUserListResult = .success(expectedUserList)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)
        let output = try await useCase.execute(input: input)

        // Then
        XCTAssertEqual(output.users.count, 1)
        XCTAssertEqual(output.users.first?.username, "username1")
        XCTAssertEqual(output.users.first?.avatarURL, "avatar1")
        XCTAssertEqual(output.users.first?.blogURL, "blog1")
        XCTAssertEqual(output.nextOffsetID, 2)
    }

    func test_execute_givenSingleUserWithExplicitNextOffset_expectSuccess() async throws {
        // Given
        let expectedUser = DMUserBrief(userID: 1, username: "username1", avatarURL: "avatar1", blogURL: "blog1")
        let expectedUserList = DMUserList(users: [expectedUser], nextOffsetID: 100)
        repository.fetchUserListResult = .success(expectedUserList)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)
        let output = try await useCase.execute(input: input)

        // Then
        XCTAssertEqual(output.users.count, 1)
        XCTAssertEqual(output.users.first?.username, "username1")
        XCTAssertEqual(output.users.first?.avatarURL, "avatar1")
        XCTAssertEqual(output.users.first?.blogURL, "blog1")
        XCTAssertEqual(output.nextOffsetID, 100)
    }

    func test_execute_givenEmptyUserResponse_expectEmptySuccess() async throws {
        // Given
        let expectedUserList = DMUserList(users: [])
        repository.fetchUserListResult = .success(expectedUserList)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)
        let output = try await useCase.execute(input: input)

        // Then
        XCTAssertTrue(output.users.isEmpty)
        XCTAssertNil(output.nextOffsetID)
    }

    func test_execute_givenEmptyUserWithExplicitNextOffset_expectSuccess() async throws {
        // Given
        let expectedUserList = DMUserList(users: [], nextOffsetID: 13)
        repository.fetchUserListResult = .success(expectedUserList)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)
        let output = try await useCase.execute(input: input)

        // Then
        XCTAssertTrue(output.users.isEmpty)
        XCTAssertEqual(output.nextOffsetID, 13)
    }

    func test_execute_givenTwentyUsersResponse_expectSuccess() async throws {
        // Given
        let fromUserID: UserID = 1
        let toUserID: UserID = 20

        let expectedUsers = (fromUserID...toUserID).map { userID in
            DMUserBrief(
                userID: userID,
                username: "username\(userID)",
                avatarURL: "avatar\(userID)",
                blogURL: "blog\(userID)"
            )
        }
        let expectedUserList = DMUserList(users: expectedUsers)
        repository.fetchUserListResult = .success(expectedUserList)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)
        let output = try await useCase.execute(input: input)

        // Then
        XCTAssertEqual(output.users.count, 20)
        XCTAssertEqual(output.users, expectedUsers)
        XCTAssertEqual(output.nextOffsetID, 21)
    }

    func test_execute_givenCacheFailure_expectThrowsError() async throws {
        // Given
        repository.fetchUserListResult = .failure(TestError.fetch)

        // When
        let input = FetchPagingUserListUseCase.Input(pageSize: 20, fromUserID: 0)

        // Then
        do {
            _ = try await useCase.execute(input: input)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, TestError.fetch)
        }
    }
}
