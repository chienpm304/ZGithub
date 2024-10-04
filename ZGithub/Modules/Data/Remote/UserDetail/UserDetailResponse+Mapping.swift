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
    let name: String?
    let company: String?
    let bio: String?
    let location: String?
    let publicRepos: Int
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case company
        case bio
        case location
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
