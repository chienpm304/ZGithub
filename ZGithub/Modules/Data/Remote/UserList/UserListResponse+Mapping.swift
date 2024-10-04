//
//  UserListResponse+Mapping.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

struct UserListResponse: Codable {
    let users: [UserBriefResponse]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.users = try container.decode([UserBriefResponse].self)
    }
}

extension UserListResponse {
    func toDomain() -> DMUserList {
        DMUserList(users: users.map({ $0.toDomain() }))
    }
}

struct UserBriefResponse: Codable {
    let userID: UserID
    let login: String
    let name: String
    let avatarURL: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case login
        case name
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}

extension UserBriefResponse {
    func toDomain() -> DMUserBrief {
        DMUserBrief(
            userID: userID,
            username: login,
            name: name,
            avatarURL: avatarURL,
            blogURL: htmlURL
        )
    }
}
