//
//  UserListSceneDIContainer.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation
import UIKit
import SwiftUI

final class UserListSceneDIContainer {
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

    func makeUserListSceneFlowCoordinator(
        from navigationController: UINavigationController
    ) -> UserListFlowCoordinator {
        UserListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension UserListSceneDIContainer: UserListFlowCoordinatorDependencies {
    func makeUserListViewController(actions: UserListViewModelActions) -> UIViewController {
        let viewModel = makeUserListViewModel(actions: actions)
        let view = UserListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    // MARK: ViewModel

    private func makeUserListViewModel(
        actions: UserListViewModelActions
    ) -> UserListViewModel {
        let dependencies = UserListViewModel.Dependencies(
            getCachedPagingUserListUseCaseFactory: makeGetCachedPagingUserListUseCase,
            fetchPagingUserListUseCaseFactory: makeFetchPagingUserListUseCase,
            actions: actions
        )
        return UserListViewModel(dependencies: dependencies)
    }

    // MARK: UseCase

    func makeGetCachedPagingUserListUseCase() -> GetCachedPagingUserListUseCase {
        GetCachedPagingUserListUseCase(repository: userRepository)
    }

    func makeFetchPagingUserListUseCase() -> FetchPagingUserListUseCase {
        FetchPagingUserListUseCase(repository: userRepository)
    }
}
