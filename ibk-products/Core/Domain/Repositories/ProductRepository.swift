//
//  ProductRepository.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import Foundation

nonisolated protocol ProductRepository: Sendable {
    func fetchProducts(offset: Int, limit: Int) -> AnyPublisher<[Product], Error>
}
