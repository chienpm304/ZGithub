//
//  DMUserList.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

struct DMUserList {
    let users: [DMUserBrief]
}

struct DMUserBrief: Identifiable, Hashable {
    let userID: UserID
    let username: String
    let avatarURL: String
    let blogURL: String

    var id: UserID { userID }
}
