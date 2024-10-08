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
    private var dataModel: UserListModel

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
    
    func formatUsername(username: String) -> String {
        "@".appending(username)
    }

    var hasMore: Bool {
        dataModel.users.count < totalLimit
    }

    var itemModels: [UserListItemModel] {
        dataModel.itemModels
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
            print("selected invalid user")
            return
        }
        dependencies.actions?.didTapUser(selectedUser)
    }
}

// MARK: Private

extension UserListViewModel {
    @MainActor
    private func loadMore(pageSize: Int, offset: UserID) async {
        guard isLoading == false, hasMore else { return }
        print("[ZGithub] > start loading: \(offset)")

        isLoading = true
        await loadUserListFromCache(pageSize, offset)
        await loadUserListFromRemote(pageSize, offset)
        isLoading = false

        print("[ZGithub] - finished loading: \(dataModel.users.map { $0.userID })")
    }

    @MainActor
    private func loadUserListFromCache(_ pageSize: Int, _ offset: UserID) async {
        do {
            let getCachedUseCase = dependencies.getCachedPagingUserListUseCaseFactory()
            let cachedUserList = try await getCachedUseCase.execute(pageSize: pageSize, fromUserID: offset)
            updateDataModel(cachedUserList)
            print("[ZGithub] loaded from cached \(cachedUserList.users.map { $0.userID })")
        } catch {
            print("[ZGithub] loaded from cached error: \(error)")
        }
    }
    
    @MainActor
    private func loadUserListFromRemote(_ pageSize: Int, _ offset: UserID) async {
        do {
            let fetchUseCase = dependencies.fetchPagingUserListUseCaseFactory()
            let remoteUserList = try await fetchUseCase.execute(pageSize: pageSize, fromUserID: offset)
            updateDataModel(remoteUserList)
            print("[ZGithub] loaded from remote \(remoteUserList.users.map { $0.userID })")
        } catch {
            print("[ZGithub] loaded from remote error: \(error)")
        }
    }

    @MainActor
    private func updateDataModel(_ userList: DMUserList) {
        dataModel.appendUniqueUserList(userList)
        if let nextOffsetID = userList.nextOffsetID {
            currentOffsetID = nextOffsetID
        }
    }
}
