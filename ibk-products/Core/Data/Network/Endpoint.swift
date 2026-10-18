//
//  Endpoint.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Foundation

nonisolated enum HTTPMethod: String, Sendable {
    case get = "GET"
}

nonisolated struct Endpoint: Sendable, Equatable {
    // MARK: - Properties

    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]

    // MARK: - Initializer

    init(path: String, method: HTTPMethod = .get, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
    }

    // MARK: - Request

    func makeRequest(baseURL: URL) throws(NetworkError) -> URLRequest {
        var components = URLComponents(url: baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components?.url else { throw .invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
