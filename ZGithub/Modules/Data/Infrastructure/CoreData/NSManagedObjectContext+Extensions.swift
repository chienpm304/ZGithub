//
//  NSManagedObjectContext+Extensions.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
}
