//
//  APIClient.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

final class APIClient: APIProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        do {
            let request = try endpoint.urlRequest()
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                throw APIError.invalidResponse
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
}
