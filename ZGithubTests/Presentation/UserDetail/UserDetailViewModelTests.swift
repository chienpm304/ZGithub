//
//  UserDetailViewModelTests.swift
//  ZGithubTests
//
//  Created by Chien Pham on 8/10/24.
//
//

import XCTest
@testable import ZGithub

fileprivate enum MockError: Error {
    case unexpected
    case someError
}

final class MockGetCachedUserDetailByUsernameUseCase: GetCachedUserDetailByUsernameUseCase {
    var result: Result<DMUserDetail, Error>!

    func execute(username: String) async throws -> ZGithub.DMUserDetail{
        switch result {
        case .success(let userDetail):
            return userDetail
        case .failure(let error):
            throw error
        case .none:
            throw MockError.unexpected
        }
    }
}

final class MockFetchUserDetailByUsernameUseCase: FetchUserDetailByUsernameUseCase {
    var result: Result<DMUserDetail, Error>!

    func execute(username: String) async throws -> ZGithub.DMUserDetail{
        switch result {
        case .success(let userDetail):
            return userDetail
        case .failure(let error):
            throw error
        case .none:
            throw MockError.unexpected
        }
    }
}

final class MockFormatFollowCountUseCase: FormatFollowCountUseCase {
    func execute(count: Int) -> String {
        "\(count)"
    }
}

final class UserDetailViewModelTests: XCTestCase {
    private var viewModel: UserDetailViewModel!
    private var mockGetCachedUserDetailUseCase: MockGetCachedUserDetailByUsernameUseCase!
    private var mockFetchUserDetailUseCase: MockFetchUserDetailByUsernameUseCase!
    private var mockFormatFollowCountUseCase: MockFormatFollowCountUseCase!
    private var mockUserDetail: DMUserDetail!

    override func setUpWithError() throws {
        mockGetCachedUserDetailUseCase = MockGetCachedUserDetailByUsernameUseCase()
        mockFetchUserDetailUseCase = MockFetchUserDetailByUsernameUseCase()
        mockFormatFollowCountUseCase = MockFormatFollowCountUseCase()

        mockUserDetail = DMUserDetail(
            userID: 1,
            username: "username1",
            name: "name 1",
            avatarURL: "avatar 1",
            blogURL: "blog 1",
            location: "location 1",
            followers: 123,
            following: 456
        )

        let dependencies = UserDetailViewModel.Dependencies(
            getCachedUserDetailUseCaseFactory: { self.mockGetCachedUserDetailUseCase },
            fetchUserDetailUseCaseFactory: { self.mockFetchUserDetailUseCase },
            formatFollowCountUseCaseFactory: { self.mockFormatFollowCountUseCase }
        )

        viewModel = UserDetailViewModel(userDetail: mockUserDetail, dependencies: dependencies)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockGetCachedUserDetailUseCase = nil
        mockFetchUserDetailUseCase = nil
        mockFormatFollowCountUseCase = nil
        mockUserDetail = nil
    }

    func test_displayName_givenUserDetail_expectCorrectDisplayName() {
        XCTAssertEqual(viewModel.displayName, "name 1")
    }

    func test_username_givenUserDetail_expectCorrectFormattedUsername() {
        XCTAssertEqual(viewModel.username, "@username1")
    }

    func test_followersCount_givenUserDetail_expectCorrectCount() {
        XCTAssertEqual(viewModel.followers, 123)
    }

    func test_followingCount_givenUserDetail_expectCorrectCount() {
        XCTAssertEqual(viewModel.following, 456)
    }

    func test_followCountFormatting_givenValidCount_expectCorrectlyFormattedFollowCount() {
        // Given
        let expectedFormattedCount = "100"

        // When
        let formattedCount = viewModel.formatFollowCountFactory(100)

        // Then
        XCTAssertEqual(formattedCount, expectedFormattedCount)
    }

    func test_onViewAppear_givenCachedUserData_expectDataModelUpdatedFromCache() async {
        // Given
        let cachedUserDetail = DMUserDetail(
            userID: 1,
            username: "cache_user",
            name: "Cached User",
            avatarURL: "avatar",
            blogURL: "blog",
            location: "location",
            followers: 3,
            following: 7
        )
        mockGetCachedUserDetailUseCase.result = .success(cachedUserDetail)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.dataModel.username, "cache_user")
        XCTAssertEqual(viewModel.dataModel.name, "Cached User")
        XCTAssertEqual(viewModel.followers, 3)
        XCTAssertEqual(viewModel.following, 7)
    }

    func test_onViewAppear_givenRemoteUserData_expectDataModelUpdatedFromRemote() async {
        // Given
        let remoteUserDetail = DMUserDetail(
            userID: 1,
            username: "remote_user",
            name: "Remote User",
            avatarURL: "avatar",
            blogURL: "blog",
            location: "location",
            followers: 3,
            following: 7
        )
        mockFetchUserDetailUseCase.result = .success(remoteUserDetail)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.dataModel.username, "remote_user")
        XCTAssertEqual(viewModel.dataModel.name, "Remote User")
        XCTAssertEqual(viewModel.followers, 3)
        XCTAssertEqual(viewModel.following, 7)
    }

    func test_onViewAppear_givenCachedAndRemoteData_expectDataModelUpdatedWithRemoteData() async {
        // Given
        let cachedUserDetail = DMUserDetail(
            userID: 1,
            username: "cache_user",
            name: "Cached User",
            avatarURL: "avatar",
            blogURL: "blog",
            location: "location",
            followers: 3,
            following: 7
        )

        let remoteUserDetail = DMUserDetail(
            userID: 1,
            username: "remote_user",
            name: "Remote User",
            avatarURL: "avatar",
            blogURL: "blog",
            location: "location",
            followers: 3,
            following: 7
        )
        mockGetCachedUserDetailUseCase.result = .success(cachedUserDetail)
        mockFetchUserDetailUseCase.result = .success(remoteUserDetail)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.dataModel.username, "remote_user")
        XCTAssertEqual(viewModel.dataModel.name, "Remote User")
    }

    func test_onViewAppear_givenCacheErrorAndRemoteError_expectDataModelNoUpdate() async {
        // Given
        mockGetCachedUserDetailUseCase.result = .failure(MockError.someError)
        mockFetchUserDetailUseCase.result = .failure(MockError.someError)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.dataModel.username, mockUserDetail.username)
        XCTAssertEqual(viewModel.dataModel.name, mockUserDetail.name)
        XCTAssertEqual(viewModel.followers, mockUserDetail.followers)
        XCTAssertEqual(viewModel.following, mockUserDetail.following)
    }
}
