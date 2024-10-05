//
//  AppFlowCoordinator.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import UIKit

final class AppFlowCoordinator {
    var window: UIWindow
    private let appDIContainer: AppDIContainer
    private var navigationController: UINavigationController?

    init(
        window: UIWindow,
        appDIContainer: AppDIContainer
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    func start() {
        let navigationController = UINavigationController()
        let mainSceneDIContainer = appDIContainer.makeUserListSceneDIContainer()
        let mainFlow = mainSceneDIContainer.makeUserListSceneFlowCoordinator(from: navigationController)
        mainFlow.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.navigationController = navigationController
    }
}
