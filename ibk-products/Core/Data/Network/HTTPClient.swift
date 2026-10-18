//
//  HTTPClient.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import Foundation

nonisolated protocol HTTPClient: Sendable {
    func request<Response: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Response, NetworkError>
}

nonisolated struct URLSessionHTTPClient: HTTPClient {
    // MARK: - Properties

    private let baseURL: URL
    private let session: URLSession

    // MARK: - Initializer

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - HTTPClient

    func request<Response: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Response, NetworkError> {
        let request: URLRequest
        do {
            request = try endpoint.makeRequest(baseURL: baseURL)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .mapError(Self.map)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpStatus(code: httpResponse.statusCode)
                }
                return output.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { error in
                (error as? NetworkError) ?? .decoding
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    private static func map(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .noConnection
        default:
            return .requestFailed
        }
    }
}
