//
//  APIEndpoint.swift
//  ZGithub
//
//  Created by Chien Pham on 04/10/2024.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

struct APIEndpoint {
    let baseURL: URL
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: Data?


    init(
        baseURL: URL,
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
    }
}

extension APIEndpoint {
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) 
        else {
            throw APIError.invalidURL
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
