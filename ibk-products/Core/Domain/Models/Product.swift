//
//  Product.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Foundation

nonisolated struct Product: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let price: Decimal
    let description: String
    let categoryName: String
    let imageURLs: [URL]
}
