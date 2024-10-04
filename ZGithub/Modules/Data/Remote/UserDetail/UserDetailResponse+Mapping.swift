//
//  UserDetailResponse+Mapping.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

struct UserDetailResponse: Codable {
    let id: Int
    let login: String
    let name: String
    let avatarURL: String
    let htmlURL: String
    let location: String
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case location
        case followers
        case following
    }
}

extension UserDetailResponse {
    func toDomain() -> DMUserDetail {
        DMUserDetail(
            id: id,
            username: login,
            name: name,
            avatarURL: avatarURL,
            blogURL: htmlURL,
            location: location,
            followers: followers,
            following: following
        )
    }
}
