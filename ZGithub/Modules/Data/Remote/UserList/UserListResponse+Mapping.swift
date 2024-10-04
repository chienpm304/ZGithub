//
//  UserListResponse+Mapping.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

struct UserListResponse: Codable {
    let users: [UserDetailResponse]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.users = try container.decode([UserDetailResponse].self)
    }
}

struct UserBriefResponse: Codable {
    let id: Int
    let login: String
    let avatarURL: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
