//
//  MockAPIClient.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

class MockAPIClient: APIProtocol {
    var result: Result<Data, APIError>?
    
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        guard let result = result else {
            throw APIError.unknown
        }
        
        switch result {
        case .success(let data):
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw APIError.decodingError(error)
            }
        case .failure(let error):
            throw error
        }
    }
}
