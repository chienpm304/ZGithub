//
//  AppDIContainer.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()

    lazy var coreDataStack: CoreDataStack = .shared

    lazy var apiClient: APIProtocol = APIClient()

    // MARK: - DIContainers of scenes

    func makeUserListSceneDIContainer() -> UserListSceneDIContainer {
        let dependencies = UserListSceneDIContainer.Dependencies(
            appConfiguration: appConfiguration,
            coreDataStack: coreDataStack,
            apiClient: apiClient,
            userDetailDIContainer: userDetailSceneDIContainer
        )
        return UserListSceneDIContainer(dependencies: dependencies)
    }

    lazy var userDetailSceneDIContainer: UserDetailSceneDIContainer = {
        let dependencies = UserDetailSceneDIContainer.Dependencies(
            appConfiguration: appConfiguration,
            coreDataStack: coreDataStack,
            apiClient: apiClient
        )
        return UserDetailSceneDIContainer(dependencies: dependencies)
    }()
}
