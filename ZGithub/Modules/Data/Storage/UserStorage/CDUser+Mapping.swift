//
//  CDUser+Mapping.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//
//

import Foundation
import CoreData

// MARK: CDUser + DMUserBrief

extension CDUser {
    func toUserBrief() -> DMUserBrief {
        DMUserBrief(
            userID: userID,
            username: username ?? "",
            avatarURL: avatarURL ?? "",
            blogURL: blogURL ?? ""
        )
    }

    convenience init(userBrief: DMUserBrief, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.update(withUserBrief: userBrief)
    }

    func update(withUserBrief userBrief: DMUserBrief) {
        self.userID = userBrief.id
        self.username = userBrief.username
        self.avatarURL = userBrief.avatarURL
        self.blogURL = userBrief.blogURL
    }
}

// MARK: CDUser + DMUserDetail

extension CDUser {
    func toUserDetail() -> DMUserDetail {
        DMUserDetail(
            userID: userID,
            username: username ?? "",
            name: name ?? "",
            avatarURL: avatarURL ?? "",
            blogURL: blogURL ?? "",
            location: location ?? "",
            followers: Int(followers),
            following: Int(following)
        )
    }

    convenience init(userDetail: DMUserDetail, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.update(withUserDetail: userDetail)
    }

    func update(withUserDetail userDetail: DMUserDetail) {
        self.userID = userDetail.id
        self.username = userDetail.username
        self.name = userDetail.name
        self.avatarURL = userDetail.avatarURL
        self.blogURL = userDetail.blogURL
        self.location = userDetail.location
        self.followers = Int32(userDetail.followers ?? 0)
        self.following = Int32(userDetail.following ?? 0)
    }
}
