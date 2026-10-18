//
//  MockProductRepository.swift
//  ibk-productsTests
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Combine
import Foundation
@testable import ibk_products

final class MockProductRepository: ProductRepository, @unchecked Sendable {
    // MARK: - Properties

    var products: [Product] = []
    var error: Error?
    var pendingResponse: PassthroughSubject<[Product], Error>?

    private(set) var requests: [(offset: Int, limit: Int)] = []

    // MARK: - Public Methods

    func fetchProducts(offset: Int, limit: Int) -> AnyPublisher<[Product], Error> {
        requests.append((offset, limit))

        if let pendingResponse {
            return pendingResponse.eraseToAnyPublisher()
        }
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }

        let page = Array(products.dropFirst(offset).prefix(limit))
        return Just(page).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
