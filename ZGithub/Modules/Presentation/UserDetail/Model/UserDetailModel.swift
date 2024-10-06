//
//  UserDetailModel.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

struct UserDetailModel {
    let id: UserID
    let username: String
    let avatarURL: String
    let blogURL: String
    let name: String?
    let location: String?
    let followers: Int?
    let following: Int?

    init(userDetail: DMUserDetail) {
        id = userDetail.userID
        username = userDetail.username
        avatarURL = userDetail.avatarURL
        blogURL = userDetail.blogURL
        name = userDetail.name
        location = userDetail.location
        followers = userDetail.followers
        following = userDetail.following
    }
}
