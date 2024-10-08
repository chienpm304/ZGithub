//
//  UserListViewModelTests.swift
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

final class MockGetCachedPagingUserListUseCase: GetCachedPagingUserListUseCase {
    var result: Result<DMUserList, Error>!

    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList {
        switch result {
        case .success(let userList):
            return userList
        case .failure(let error):
            throw error
        case .none:
            throw MockError.unexpected
        }
    }
}

final class MockFetchPagingUserListUseCase: FetchPagingUserListUseCase {
    var result: Result<DMUserList, Error>!

    func execute(pageSize: Int, fromUserID: UserID) async throws -> DMUserList {
        switch result {
        case .success(let userList):
            return userList
        case .failure(let error):
            throw error
        case .none:
            throw MockError.unexpected
        }
    }
}

final class MockUserListViewModelActions {
    var didTapUserCalled = false
    var selectedUser: DMUserBrief?
    
    func didTapUser(_ user: DMUserBrief) {
        didTapUserCalled = true
        selectedUser = user
    }
}

final class UserListViewModelTests: XCTestCase {
    private var viewModel: UserListViewModel!
    
    private var mockGetCachedUseCase: MockGetCachedPagingUserListUseCase!
    private var mockFetchUseCase: MockFetchPagingUserListUseCase!
    private var mockActions: MockUserListViewModelActions!
    
    override func setUpWithError() throws {
        mockGetCachedUseCase = MockGetCachedPagingUserListUseCase()
        mockFetchUseCase = MockFetchPagingUserListUseCase()
        mockActions = MockUserListViewModelActions()
        
        let dependencies = UserListViewModel.Dependencies(
            getCachedPagingUserListUseCaseFactory: { self.mockGetCachedUseCase },
            fetchPagingUserListUseCaseFactory: { self.mockFetchUseCase },
            actions: UserListViewModelActions(didTapUser: mockActions.didTapUser(_:))
        )
        
        viewModel = UserListViewModel(dependencies: dependencies)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockGetCachedUseCase = nil
        mockFetchUseCase = nil
        mockActions = nil
    }
    
    func test_initialState_givenNoData_expectEmptyListAndNotLoadingAndHasMore() {
        XCTAssertEqual(viewModel.itemModels.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }
    
    func test_onViewAppear_givenCachedAndRemoteData_expectUserItemsToLoad() async {
        // Given
        let mockUsers = [
            DMUserBrief(userID: 1, username: "user1", avatarURL: "avatar1", blogURL: "blog1"),
            DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        ]
        mockGetCachedUseCase.result = .success(DMUserList(users: mockUsers))
        mockFetchUseCase.result = .success(DMUserList(users: mockUsers))

        // When
        await viewModel.onViewAppear()
        
        // Then
        XCTAssertEqual(viewModel.itemModels.count, mockUsers.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_onViewAppear_givenExistedDataModel_expectNoExtraLoading() async {
        // Given
        let mockUsers = [
            DMUserBrief(userID: 3, username: "user3", avatarURL: " ", blogURL: " "),
            DMUserBrief(userID: 4, username: "user4", avatarURL: " ", blogURL: " ")
        ]
        mockGetCachedUseCase.result = .success(DMUserList(users: mockUsers))
        mockFetchUseCase.result = .success(DMUserList(users: mockUsers))

        await viewModel.onViewAppear() // already called onViewAppear

        let moreMockUsers = [
            DMUserBrief(userID: 0, username: "user0", avatarURL: "avatar0", blogURL: "blog0"),
            DMUserBrief(userID: 1, username: "user1", avatarURL: "avatar1", blogURL: "blog1"),
            DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        ]

        mockGetCachedUseCase.result = .success(DMUserList(users: moreMockUsers))
        mockFetchUseCase.result = .success(DMUserList(users: moreMockUsers))

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.itemModels.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_onViewAppear_givenCachedDataAndRemoteError_expectUserItemsToLoad() async {
        // Given
        let mockUsers = [
            DMUserBrief(userID: 1, username: "user1", avatarURL: "avatar1", blogURL: "blog1"),
            DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        ]
        mockGetCachedUseCase.result = .success(DMUserList(users: mockUsers))
        mockFetchUseCase.result = .failure(MockError.someError)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.itemModels.count, mockUsers.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_onViewAppear_givenRemoteDataAndCacheError_expectUserItemsToLoad() async {
        // Given
        let mockUsers = [
            DMUserBrief(userID: 1, username: "user1", avatarURL: "avatar1", blogURL: "blog1"),
            DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        ]
        mockGetCachedUseCase.result = .failure(MockError.someError)
        mockFetchUseCase.result = .success(DMUserList(users: mockUsers))

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.itemModels.count, mockUsers.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_onViewAppear_givenRemoteDataAndCacheError_expectCannotLoad() async {
        // Given
        mockGetCachedUseCase.result = .failure(MockError.someError)
        mockFetchUseCase.result = .failure(MockError.someError)

        // When
        await viewModel.onViewAppear()

        // Then
        XCTAssertEqual(viewModel.itemModels.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_onAppearUserListItem_givenLastItemAndEmptyCache_expectLoadMoreUsers() async {
        // Given
        let lastUser = DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        let moreUsers = [
            DMUserBrief(userID: 3, username: "user3", avatarURL: "avatar3", blogURL: "blog3"),
            DMUserBrief(userID: 4, username: "user4", avatarURL: "avatar4", blogURL: "blog4"),
        ]
        mockGetCachedUseCase.result = .success(DMUserList(users: []))
        mockFetchUseCase.result = .success(DMUserList(users: moreUsers))

        await viewModel.onViewAppear()
        
        // When the last item appears, it should load more users.
        await viewModel.onAppearUserListItem(.init(userBrief: lastUser))
        
        // Then
        XCTAssertEqual(viewModel.itemModels.count, 2, "Expect 2 new users added from remote")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_onAppearUserListItem_givenLastItemAndEmptyRemote_expectLoadMoreUsers() async {
        // Given
        let lastUser = DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        let moreUsers = [
            DMUserBrief(userID: 3, username: "user3", avatarURL: "avatar3", blogURL: "blog3"),
            DMUserBrief(userID: 4, username: "user4", avatarURL: "avatar4", blogURL: "blog4"),
        ]
        mockGetCachedUseCase.result = .success(DMUserList(users: moreUsers))
        mockFetchUseCase.result = .success(DMUserList(users: []))

        await viewModel.onViewAppear()
        
        // When the last item appears, it should load more users.
        await viewModel.onAppearUserListItem(.init(userBrief: lastUser))
        
        // Then
        XCTAssertEqual(viewModel.itemModels.count, 2, "Expect 2 new users added from local")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_didTapUserListItem_givenSelectedUser_expectActionToTrigger() async {
        // Given
        let mockUser = DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        mockGetCachedUseCase.result = .success(DMUserList(users: [mockUser]))

        await viewModel.onViewAppear()
        
        // When
        await viewModel.didTapUserListItem(viewModel.itemModels.first!)
        
        // Then
        XCTAssertTrue(mockActions.didTapUserCalled, "Did tap user should be called")
        XCTAssertEqual(mockActions.selectedUser?.id, mockUser.id)
    }

    func test_didTapUserListItem_givenInvalidSelectedUser_expectActionToTrigger() async {
        // Given
        let mockUser = DMUserBrief(userID: 2, username: "user2", avatarURL: "avatar2", blogURL: "blog2")
        mockGetCachedUseCase.result = .success(DMUserList(users: [mockUser]))

        let invalidUser = DMUserBrief(userID: 100, username: "user100", avatarURL: "avatar100", blogURL: "blog100")

        await viewModel.onViewAppear()

        // When
        await viewModel.didTapUserListItem(.init(userBrief: invalidUser))

        // Then
        XCTAssertFalse(mockActions.didTapUserCalled, "Did tap user should not be called")
        XCTAssertNil(mockActions.selectedUser)
    }

    func test_formatUsername_givenUsername_expectFormattedWithAtPrefix() {
        let username = "testuser"
        let formattedUsername = viewModel.formatUsername(username: username)
        XCTAssertEqual(formattedUsername, "@testuser")
    }
    
    func test_hasMore_givenUserCountUnreachedLimit_expectHasMoreTrye() async {
        // Given
        let mockUsers = (1...100).map {
            DMUserBrief(userID: $0, username: "user\($0)", avatarURL: "", blogURL: "")
        }
        mockGetCachedUseCase.result = .success(DMUserList(users: mockUsers))

        // When
        await viewModel.onViewAppear()
        
        // Then
        XCTAssertTrue(viewModel.hasMore)
    }
    
    func test_hasMore_givenUserCountReachedLimit_expectHasMoreFalse() async {
        // Given
        let mockUsers = (1...2000).map {
            DMUserBrief(userID: $0, username: "user\($0)", avatarURL: "", blogURL: "")
        }
        mockGetCachedUseCase.result = .success(DMUserList(users: mockUsers))

        // When
        await viewModel.onViewAppear()
        
        // Then
        XCTAssertFalse(viewModel.hasMore)
    }
}

