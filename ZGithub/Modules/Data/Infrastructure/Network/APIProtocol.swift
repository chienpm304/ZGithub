//
//  APIProtocol.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

protocol APIProtocol {
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T
}
