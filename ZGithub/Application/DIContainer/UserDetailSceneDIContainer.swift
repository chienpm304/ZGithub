//
//  UserDetailSceneDIContainer.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//
//

import Foundation
import SwiftUI
import UIKit

final class UserDetailSceneDIContainer {
    struct Dependencies {
        let appConfiguration: AppConfiguration
        let coreDataStack: CoreDataStack
        let apiClient: APIProtocol
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Lazy Properties

    lazy var userStorage: UserStorage = UserCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    lazy var userEndpointFactory: UserEndpointFactory = {
        let apiConfig = dependencies.appConfiguration.githubAPIConfig
        return GithubUserEndpointFactory(config: apiConfig)
    } ()

    lazy var userRepository: UserRepository = DefaultUserRepository(
        apiClient: dependencies.apiClient,
        userEndpointFactory: userEndpointFactory,
        userStorage: userStorage
    )

    // MARK: Flow

    func makeUserDetailSceneFlowCoordinator(
        from navigationController: UINavigationController,
        input: UserDetailFlowCoordinator.Input
    ) -> UserDetailFlowCoordinator {
        UserDetailFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            input: input
        )
    }
}

extension UserDetailSceneDIContainer: UserDetailFlowCoordinatorDependencies {
    func makeUserDetailViewController(userDetail: DMUserDetail) -> UIViewController {
        let viewModel = makeUserDetailViewModel(userDetail: userDetail)
        let view = UserDetailView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        return viewController
    }

    // MARK: ViewModel

    private func makeUserDetailViewModel(userDetail: DMUserDetail) -> UserDetailViewModel {
        let dependencies = UserDetailViewModel.Dependencies(
            getCachedUserDetailUseCaseFactory: makeGetCachedUserDetailByUsernameUseCase,
            fetchUserDetailUseCaseFactory: makeFetchUserDetailByUsernameUseCase,
            formatFollowCountUseCaseFactory: makeFormatFollowCountUseCase
        )
        return UserDetailViewModel(userDetail: userDetail, dependencies: dependencies)
    }

    // MARK: UseCase

    func makeGetCachedUserDetailByUsernameUseCase() -> GetCachedUserDetailByUsernameUseCase {
        GetCachedUserDetailByUsernameUseCase(repository: userRepository)
    }

    func makeFetchUserDetailByUsernameUseCase() -> FetchUserDetailByUsernameUseCase {
        FetchUserDetailByUsernameUseCase(repository: userRepository)
    }

    func makeFormatFollowCountUseCase() -> FormatFollowCountUseCase {
        FormatFollowCountUseCase()
    }
}
