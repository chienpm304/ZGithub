//
//  UserStorage.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol UserStorage {
    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList

    func saveUserList(_ userList: DMUserList) async throws

    func fetchUserDetail(username: String) async throws -> DMUserDetail?

    func saveUserDetail(_ userDetail: DMUserDetail) async throws
}
