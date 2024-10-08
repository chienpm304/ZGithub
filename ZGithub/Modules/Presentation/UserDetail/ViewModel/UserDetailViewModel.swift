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
        dataModel.name ?? "@\(dataModel.username)"
    }

    var username: String {
        "@\(dataModel.username)"
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
            .execute(count:)
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
        await loadDataFromCache()
        await loadDataFromRemote()
        print("[ZGithub] loaded detail: \(dataModel.username)")
    }

    @MainActor
    private func loadDataFromCache() async {
        do {
            let getCachedUseCase = dependencies.getCachedUserDetailUseCaseFactory()
            let cachedUserDetail = try await getCachedUseCase.execute(username: userDetail.username)
            updateDataModel(with: cachedUserDetail)
            print("[ZGithub] loaded from cached \(cachedUserDetail)")
        } catch {
            print("[ZGithub] loaded from cached error: \(error)")
        }
    }

    @MainActor
    private func loadDataFromRemote() async {
        do {
            let fetchUseCase = dependencies.fetchUserDetailUseCaseFactory()
            let remoteUserDetail = try await fetchUseCase.execute(username: userDetail.username)
            updateDataModel(with: remoteUserDetail)
            print("[ZGithub] loaded from remote \(remoteUserDetail)")
        } catch {
            print("[ZGithub] loaded from remote error: \(error)")
        }
    }

    @MainActor
    private func updateDataModel(with userDetail: DMUserDetail) {
        dataModel = UserDetailModel(userDetail: userDetail)
    }
}
