//
//  UserListViewModel.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//
//

import Foundation

struct UserListViewModelActions {
    let didTapUser: (DMUserBrief) -> Void
}

final class UserListViewModel: ObservableObject {
    struct Dependencies {
        let getCachedPagingUserListUseCaseFactory: GetCachedPagingUserListUseCaseFactory
        let fetchPagingUserListUseCaseFactory: FetchPagingUserListUseCaseFactory
        let actions: UserListViewModelActions?
    }

    // MARK: Properties

    private let totalLimit: Int
    private let pageSize: Int
    private var currentOffsetID: UserID
    private let dependencies: Dependencies

    @Published
    private(set) var isLoading: Bool

    @Published
    private(set) var dataModel: UserListModel

    // MARK: Initializer

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.totalLimit = 200
        self.pageSize = 20
        self.currentOffsetID = 0
        self.isLoading = false
        self.dataModel = UserListModel(userList: DMUserList(users: []))
    }

    // MARK: Public
    
    var hasMore: Bool {
        dataModel.users.count < totalLimit
    }

    @MainActor
    func onViewAppear() async {
        guard dataModel.isEmpty else { return }
        currentOffsetID = 0
        await loadMore(pageSize: pageSize, offset: currentOffsetID)
    }

    @MainActor 
    func onAppearUserListItem(_ item: UserListItemModel) async {
        if item.id == dataModel.lastUser?.id {
            await loadMore(pageSize: pageSize, offset: currentOffsetID)
        }
    }

    @MainActor 
    func didTapUserListItem(_ item: UserListItemModel) {
        guard let selectedUser = dataModel.getUser(by: item.id) else {
            assertionFailure()
            return
        }
        dependencies.actions?.didTapUser(selectedUser)
    }

    // MARK: Private

    @MainActor
    private func loadMore(pageSize: Int, offset: UserID) async {
        guard isLoading == false, hasMore else { return }
        print("[ZGithub] > start loading: \(offset)")
        do {
            isLoading = true
            try await loadUserListFromCache(pageSize, offset)
            try await loadUserListFromRemote(pageSize, offset)
            isLoading = false
            if let lastUser = dataModel.lastUser {
                currentOffsetID = lastUser.userID + 1
            }
        } catch {
            isLoading = false
            if let lastUser = dataModel.lastUser {
                currentOffsetID = lastUser.userID + 1
            }
            print("[ZGithub] load more offset: \(offset), error: \(error)")
        }
    }

    @MainActor
    private func loadUserListFromCache(_ pageSize: Int, _ offset: UserID) async throws {
        let requestCacheInput = GetCachedPagingUserListUseCase.Input(
            pageSize: pageSize,
            fromUserID: offset
        )
        let getCachedUseCase = dependencies.getCachedPagingUserListUseCaseFactory()
        let cachedUserList = try await getCachedUseCase.execute(input: requestCacheInput)
        dataModel.appendUniqueUserList(cachedUserList)
        print("[ZGithub] loaded from cached \(cachedUserList.users.map { $0.userID })")
    }

    @MainActor
    private func loadUserListFromRemote(_ pageSize: Int, _ offset: UserID) async throws {
        let fetchInput = FetchPagingUserListUseCase.Input(pageSize: pageSize, fromUserID: offset)
        let fetchUseCase = dependencies.fetchPagingUserListUseCaseFactory()
        let remoteUserList = try await fetchUseCase.execute(input: fetchInput)
        dataModel.appendUniqueUserList(remoteUserList)
        print("[ZGithub] loaded from remote \(remoteUserList.users.map { $0.userID })")
    }
}
