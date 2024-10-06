//
//  UserDetailRepository.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import Foundation

protocol UserDetailRepository {

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
