//
//  UserDetailViewModel.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

final class UserDetailViewModel: ObservableObject {
    struct Dependencies {
        let getCachedUserDetailUseCaseFactory: GetCachedUserDetailByUsernameUseCaseFactory
        let fetchUserDetailUseCaseFactory: FetchUserDetailByUsernameUseCaseFactory
        let formatFollowCountUseCaseFactory: FormatFollowCountUseCaseFactory
    }

    // MARK: Properties

    private let userDetail: DMUserDetail
    private let dependencies: Dependencies

    @Published
    private(set) var dataModel: UserDetailModel


    // MARK: Inititalier

    init(userDetail: DMUserDetail, dependencies: Dependencies) {
        self.userDetail = userDetail
        self.dependencies = dependencies
        self.dataModel = UserDetailModel(userDetail: userDetail)
    }

    // MARK: Public

    var displayName: String {
        dataModel.name ?? dataModel.username.capitalized
    }

    var followers: Int {
        dataModel.followers ?? 0
    }

    var following: Int {
        dataModel.following ?? 0
    }

    var formatFollowCountFactory: ((Int) -> String) {
        dependencies
            .formatFollowCountUseCaseFactory()
            .execute(input:)
    }

    @MainActor
    func onViewAppear() async {
        await refreshData()
    }
}

// MARK: Private

extension UserDetailViewModel {

    @MainActor
    private func refreshData() async {
        do {
            try await loadDataFromCache()
            try await loadDataFromRemote()
        } catch {
            print("[ZGithub] load detail: \(dataModel.username), error: \(error)")
        }
    }

    @MainActor
    private func loadDataFromCache() async throws {
        let requestCacheInput = GetCachedUserDetailByUsernameUseCase.Input(
            username: userDetail.username
        )
        let getCachedUseCase = dependencies.getCachedUserDetailUseCaseFactory()
        let cachedUserDetail = try await getCachedUseCase.execute(input: requestCacheInput)
        updateDataModel(with: cachedUserDetail)
        print("[ZGithub] loaded from cached \(cachedUserDetail)")
    }

    @MainActor
    private func loadDataFromRemote() async throws {
        let fetchInput = FetchUserDetailByUsernameUseCase.Input(
            username: userDetail.username
        )
        let fetchUseCase = dependencies.fetchUserDetailUseCaseFactory()
        let remoteUserDetail = try await fetchUseCase.execute(input: fetchInput)
        updateDataModel(with: remoteUserDetail)
        print("[ZGithub] loaded from remote \(remoteUserDetail)")
    }

    @MainActor
    private func updateDataModel(with userDetail: DMUserDetail) {
        dataModel = UserDetailModel(userDetail: userDetail)
    }
}
