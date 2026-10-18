//
//  RemoteProductRepository.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import Foundation

nonisolated struct RemoteProductRepository: ProductRepository {
    // MARK: - Properties

    private let httpClient: any HTTPClient

    // MARK: - Initialization

    init(httpClient: any HTTPClient) {
        self.httpClient = httpClient
    }

    // MARK: - Public Methods

    func fetchProducts(offset: Int, limit: Int) -> AnyPublisher<[Product], Error> {
        httpClient.request(.products(offset: offset, limit: limit))
            .map { (dtos: [ProductDTO]) in dtos.map { $0.toDomain() } }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

// MARK: - Endpoints

nonisolated private extension Endpoint {
    static func products(offset: Int, limit: Int) -> Endpoint {
        Endpoint(
            path: "products",
            queryItems: [
                URLQueryItem(name: "offset", value: String(offset)),
                URLQueryItem(name: "limit", value: String(limit)),
            ]
        )
    }
}
