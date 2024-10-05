//
//  UserListModel.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

struct UserListModel {
    private(set) var users: [DMUserBrief]

    init(userList: DMUserList) {
        self.users = userList.users
    }

    var isEmpty: Bool {
        users.isEmpty
    }

    var itemModels: [UserListItemModel] {
        users.map {
            UserListItemModel(userBrief: $0)
        }
    }

    var lastUser: DMUserBrief? {
        users.last
    }

    func getUser(by userID: UserID) -> DMUserBrief? {
        users.first { $0.userID == userID }
    }

    mutating func appendUniqueUserList(_ userList: DMUserList) {
        let newUsers = userList.users
        let newUserSet = Set(newUsers)
        users.removeAll { newUserSet.contains($0) }
        users.append(contentsOf: newUsers)
    }
}
