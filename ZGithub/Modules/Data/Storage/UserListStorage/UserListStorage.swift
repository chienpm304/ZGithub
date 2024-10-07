//
//  UserListStorage.swift
//  ZGithub
//
//  Created by Chien Pham on 7/10/24.
//  
//

import Foundation

protocol UserListStorage {
    /// Fetches a paginated list of users brief, starting from a given `userID` and fetching up to `pageSize` users.
    ///
    /// - Parameters:
    ///   - pageSize: The maximum number of users to fetch in one request.
    ///   - offsetBy: The `userID` from which the pagination should start. Only users with `userID` greater than or equal (>=) this value will be fetched.
    /// - Returns: A `DMUserList` object containing a list of users starting after the provided `userID`.
    /// - Throws: `StorageError.fetchError` if there is an issue retrieving the data.
    ///
    /// - Important: Since `userID` is not sequential, but generally increasing, pagination is handled by fetching users with a `userID` greater than the provided offset.
    /// Ensure that `userID` is unique and properly indexed for efficient querying.
    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList

    /// Add or insert a list of users in the database.
    ///
    /// - Parameters:
    ///   - userList: A list of user brief models (`DMUserList`) to be saved or updated.
    /// - Throws: `StorageError.saveError` if there is an issue with saving the data.
    ///
    /// - Discussion: This method performs an upsert operation on the list of users. If a user with the same `userID` exists in the database, it will be updated.
    /// Otherwise, a new user will be created. The method is optimized to fetch existing users in bulk to avoid multiple queries.
    func saveUserList(_ userList: DMUserList) async throws
}
