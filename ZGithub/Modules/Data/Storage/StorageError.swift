//
//  StorageError.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

enum StorageError: Error {
    case notFound
    case fetchError(Error)
    case saveError(Error)
    case unknown(Error)
}
