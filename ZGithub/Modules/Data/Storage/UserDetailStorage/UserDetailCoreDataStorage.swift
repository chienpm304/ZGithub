//
//  UserCoreDataStorage.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//
//

import Foundation
import CoreData

final class UserDetailCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
}

extension UserDetailCoreDataStorage: UserDetailStorage {
    func fetchUserDetail(username: String) async throws -> DMUserDetail {
        try await coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDUser.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@", username as CVarArg)
                if let entity = try context.fetch(fetchRequest).first {
                    return entity.toUserDetail()
                } else {
                    throw StorageError.notFound
                }
            } catch {
                throw StorageError.unknown(error)
            }
        }
    }

    func saveUserDetail(_ userDetail: DMUserDetail) async throws {
        try await coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDUser.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "userID == %ld", userDetail.userID)

                let fetchedUsers = try context.fetch(fetchRequest)
                if let user = fetchedUsers.first {
                    user.update(withUserDetail: userDetail)
                } else {
                    _ = CDUser(userDetail: userDetail, insertInto: context)
                }

                try context.saveIfNeeded()
            } catch {
                throw StorageError.saveError(error)
            }
        }
    }
}
