//
//  UserStorage.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

protocol UserDetailStorage {
    /// Fetches the detailed user information for a specific user by their username.
    ///
    /// - Parameters:
    ///   - username: The username of the user to fetch details for.
    /// - Returns: A `DMUserDetail` object containing detailed user information.
    /// - Throws: `StorageError.notFound` if the user is not found, or `StorageError.unknown` for other issues.
    ///
    /// - Discussion: This method retrieves a single user's details based on their unique username. 
    /// If the user is not found, the method throws a `StorageError.notFound` error.
    /// The fetch request is optimized for retrieving a single user.
    func fetchUserDetail(username: String) async throws -> DMUserDetail

    /// Saves or updates a user's detailed information in the database.
    ///
    /// - Parameters:
    ///   - userDetail: The `DMUserDetail` model containing the detailed information of the user to be saved or updated.
    /// - Throws: `StorageError.saveError` if there is an issue with saving the data.
    ///
    /// - Discussion: This method performs an upsert operation on a single user's detailed information.
    /// If a user with the same `userID` already exists, it will be updated; otherwise, a new user will be created.
    /// It ensures data consistency by updating existing records where applicable.
    func saveUserDetail(_ userDetail: DMUserDetail) async throws
}
