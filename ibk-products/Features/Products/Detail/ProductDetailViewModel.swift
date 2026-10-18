//
//  ProductDetailViewModel.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Foundation

final class ProductDetailViewModel {
    // MARK: - Properties

    let title: String
    let formattedPrice: String
    let categoryName: String
    let description: String
    let imageURL: URL?

    // MARK: - Initialization

    init(product: Product) {
        self.title = product.title
        self.formattedPrice = product.price.formatted(.currency(code: "USD"))
        self.categoryName = product.categoryName
        self.description = product.description
        self.imageURL = product.imageURLs.first
    }
}

extension ProductDetailViewModel {
    static func make(product: Product) -> ProductDetailViewModel {
        .init(product: product)
    }
}
