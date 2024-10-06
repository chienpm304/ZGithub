//
//  UserDetailFlowCoordinator.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation
import UIKit

protocol UserDetailFlowCoordinatorDependencies {
    func makeUserDetailViewController(userDetail: DMUserDetail) -> UIViewController
}

final class UserDetailFlowCoordinator {
    struct Input {
        let userDetail: DMUserDetail
    }

    private weak var navigationController: UINavigationController?
    private let dependencies: UserDetailFlowCoordinatorDependencies
    private let input: Input

    init(
        navigationController: UINavigationController? = nil,
        dependencies: UserDetailFlowCoordinatorDependencies,
        input: Input
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.input = input
    }

    func start() {
        let viewController = dependencies.makeUserDetailViewController(
            userDetail: input.userDetail
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}
