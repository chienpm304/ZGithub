//
//  UserRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol UserRepository {
    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList

    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList

    func getCachedUserDetail(username: String) async throws -> DMUserDetail

    func fetchUserDetail(username: String) async throws -> DMUserDetail
}
