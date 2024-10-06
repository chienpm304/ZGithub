//
//  UserListRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

protocol UserListRepository {

    /// Retrieves a paginated list of cached users from local storage, starting from a given `userID`.
    ///
    /// - Parameters:
    ///   - pageSize: The maximum number of users to retrieve in one request.
    ///   - offsetBy: The `userID` from which the pagination should start. Only users with `userID` greater than this value will be fetched.
    /// - Returns: A `DMUserList` object containing cached user data from local storage.
    /// - Throws: An error if there is an issue retrieving the data from local storage.
    ///
    /// - Discussion: This method fetches user data from local storage (e.g., Core Data) without interacting with remote sources.
    /// It's used to quickly retrieve already cached users for offline access or performance optimization.
    func getCachedUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList

    /// Fetches a paginated list of users from a remote source, and caches the data in local storage.
    ///
    /// - Parameters:
    ///   - pageSize: The maximum number of users to fetch in one request.
    ///   - offsetBy: The `userID` from which the pagination should start. Only users with `userID` greater than this value will be fetched.
    /// - Returns: A `DMUserList` object containing user data fetched from the remote source.
    /// - Throws: An error if there is an issue fetching the data from the remote source or saving it to local storage.
    ///
    /// - Discussion: This method retrieves fresh user data from a remote API or service, and subsequently updates the local storage with the fetched data.
    /// It is useful when a more up-to-date list of users is required than what is available locally.
    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList
}
