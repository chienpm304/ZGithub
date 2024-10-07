//
//  MockAPIClient.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation
@testable import ZGithub

final class MockAPIClient: APIProtocol {
    private enum MockError: Error {
        case unxpected
    }

    var result: Result<Data, Error>?

    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        guard let result = result else {
            throw MockError.unxpected
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
