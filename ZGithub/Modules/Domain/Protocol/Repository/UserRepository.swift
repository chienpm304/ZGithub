//
//  UserRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol UserRepository {

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

    /// Retrieves the cached detailed information of a specific user from local storage.
    ///
    /// - Parameters:
    ///   - username: The username of the user whose details are to be fetched.
    /// - Returns: A `DMUserDetail` object containing cached user detail data.
    /// - Throws: An error if there is an issue retrieving the data from local storage or if the user is not found.
    ///
    /// - Discussion: This method retrieves detailed information of a user from local storage, providing offline access to user details. 
    /// The data might be outdated if the user has not been fetched recently from the remote source.
    func getCachedUserDetail(username: String) async throws -> DMUserDetail

    /// Fetches detailed user information from a remote source, and caches the data in local storage.
    ///
    /// - Parameters:
    ///   - username: The username of the user whose details are to be fetched.
    /// - Returns: A `DMUserDetail` object containing user detail data fetched from the remote source.
    /// - Throws: An error if there is an issue fetching the data from the remote source or saving it to local storage.
    ///
    /// - Discussion: This method retrieves up-to-date user details from a remote, ensuring that the latest information is saved
    /// in local storage for future access. It is used when fresh user detail data is required, or when the user is not found in the local cache.
    func fetchUserDetail(username: String) async throws -> DMUserDetail
}
