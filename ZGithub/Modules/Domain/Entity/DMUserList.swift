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
    let nextOffsetID: UserID?

    init(users: [DMUserBrief], nextOffsetID: UserID? = nil) {
        self.users = users
        
        if let nextOffsetID {
            self.nextOffsetID = nextOffsetID
        } else if let lastUserID = users.last?.userID {
            self.nextOffsetID = lastUserID + 1
        } else {
            self.nextOffsetID = nil
        }
    }
}

struct DMUserBrief: Identifiable, Hashable {
    let userID: UserID
    let username: String
    let avatarURL: String
    let blogURL: String

    var id: UserID { userID }
}

extension DMUserBrief {
    func toUserDetail() -> DMUserDetail {
        DMUserDetail(
            userID: userID,
            username: username,
            name: username.capitalized,
            avatarURL: avatarURL,
            blogURL: blogURL,
            location: "",
            followers: 0,
            following: 0
        )
    }
}
