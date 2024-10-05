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
    let name: String
    let avatarURL: String
    let blogURL: String

    init(userBrief: DMUserBrief) {
        id = userBrief.userID
        name = userBrief.username.capitalized
        avatarURL = userBrief.avatarURL
        blogURL = userBrief.blogURL
    }
}
