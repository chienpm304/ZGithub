//
//  APIError.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
    case unknown
}
