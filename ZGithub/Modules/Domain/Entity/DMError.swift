//
//  DMError.swift
//  ZGithub
//
//  Created by Chien Pham on 4/10/24.
//  
//

import Foundation

enum DMError: Error {
    case storageError(Error)
    case apiError(Error)
    case unknown(Error)
}
