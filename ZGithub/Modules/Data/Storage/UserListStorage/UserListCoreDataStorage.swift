//
//  UserListCoreDataStorage.swift
//  ZGithub
//
//  Created by Chien Pham on 7/10/24.
//
//

import Foundation
import CoreData

final class UserListCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
}

extension UserListCoreDataStorage: UserListStorage {
    func fetchUserList(pageSize: Int, offsetBy userID: UserID) async throws -> DMUserList {
        try await coreData.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = CDUser.fetchRequest()
                request.predicate = NSPredicate(format: "userID >= %ld", userID)
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDUser.userID), ascending: true)
                ]
                request.fetchLimit = pageSize
                request.propertiesToFetch = ["userID", "username", "name", "avatarURL", "blogURL"]

                let users = try context.fetch(request).map { $0.toUserBrief() }
                return DMUserList(users: users)
            } catch {
                throw StorageError.fetchError(error)
            }
        }
    }

    func saveUserList(_ userList: DMUserList) async throws {
        try await coreData.performBackgroundTask { context in
            do {
                let users = userList.users
                let userIDs = users.map { $0.userID }

                let fetchRequest = CDUser.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "userID IN %@", userIDs)

                let existingUsers = try context.fetch(fetchRequest)
                let existingUsersByID = Dictionary(uniqueKeysWithValues: existingUsers.map { ($0.userID, $0) })

                for userBrief in users {
                    if let existingUser = existingUsersByID[userBrief.userID] {
                        existingUser.update(withUserBrief: userBrief)
                    } else {
                        _ = CDUser(userBrief: userBrief, insertInto: context)
                    }
                }

                try context.saveIfNeeded()
            } catch {
                throw StorageError.saveError(error)
            }
        }
    }
}
