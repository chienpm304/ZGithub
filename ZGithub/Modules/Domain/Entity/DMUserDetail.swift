//
//  DMUserDetail.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

struct DMUserDetail: Identifiable {
    let userID: UserID
    let username: String
    let name: String
    let avatarURL: String
    let blogURL: String
    let location: String
    let followers: Int
    let following: Int

    var id: UserID { userID }
}
