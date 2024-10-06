//
//  UserListFlowCoordinator.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation
import UIKit

protocol UserListFlowCoordinatorDependencies {
    func makeUserListViewController(actions: UserListViewModelActions) -> UIViewController

    func makeUserDetailFlowCoordinator(
        from navigationController: UINavigationController,
        input: UserDetailFlowCoordinator.Input
    ) -> UserDetailFlowCoordinator
}

final class UserListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: UserListFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController? = nil,
        dependencies: UserListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = UserListViewModelActions(didTapUser: didTapUser)
        let userListViewController = dependencies.makeUserListViewController(actions: actions)
        navigationController?.pushViewController(userListViewController, animated: true)
    }

    private func didTapUser(_ user: DMUserBrief) {
        print("did tap user \(user)")
        guard let navigationController else { return }
        let input = UserDetailFlowCoordinator.Input(userDetail: user.toUserDetail())
        dependencies
            .makeUserDetailFlowCoordinator(from: navigationController, input: input)
            .start()
    }
}
