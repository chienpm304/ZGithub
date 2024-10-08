//
//  UserListItemModel.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import Foundation

struct UserListItemModel: Identifiable {
    let id: UserID
    let username: String
    let avatarURL: String
    let blogURL: String

    init(userBrief: DMUserBrief) {
        id = userBrief.userID
        username = userBrief.username
        avatarURL = userBrief.avatarURL
        blogURL = userBrief.blogURL
    }
}
