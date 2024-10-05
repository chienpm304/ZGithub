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

//    func makeUserDetailFlowCoordinator(
//        from navigationController: UINavigationController,
//        input: UserDetailFlowCoordinator.Input,
//    ) -> UserDetailFlowCoordinator
}

final class UserListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: UserListFlowCoordinatorDependencies
    private var UserListViewController: UIViewController?
    private var UserListViewModel: UserListViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: UserListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    public func start() {
        let actions = UserListViewModelActions(didTapUser: didTapUser)
        let userListViewController = dependencies.makeUserListViewController(actions: actions)
        navigationController?.pushViewController(userListViewController, animated: true)
    }

    private func didTapUser(_ user: DMUserBrief) {
        print("did tap user \(user)")
//        let actions = CategoryDetailViewModelActions { [weak self] _ in
//            guard let self else { return }
//            if let listViewController = self.UserListViewController {
//                self.navigationController?.popToViewController(listViewController, animated: true)
//            }
//            Task { @MainActor [weak self] in
//                await self?.UserListViewModel?.refreshData()
//            }
//        }
//        let detailVC = dependencies.makeCategoryDetailViewController(
//            category: category,
//            isNewCategory: isNewCategory,
//            actions: actions
//        )
//        navigationController?.pushViewController(detailVC, animated: true)
    }

}
