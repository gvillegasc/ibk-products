//
//  ProductDTO.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Foundation

nonisolated struct ProductDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let price: Decimal
    let description: String
    let category: CategoryDTO
    let images: [String]
}

nonisolated struct CategoryDTO: Decodable, Sendable {
    let name: String
}

// MARK: - Extensions

nonisolated extension ProductDTO {
    func toDomain() -> Product {
        Product(
            id: id,
            title: title,
            price: price,
            description: description,
            categoryName: category.name,
            imageURLs: images.compactMap(Self.imageURL(from:))
        )
    }

    private static func imageURL(from rawValue: String) -> URL? {
        let wrappingCharacters = CharacterSet(charactersIn: "[]\"").union(.whitespacesAndNewlines)
        let cleaned = rawValue.trimmingCharacters(in: wrappingCharacters)

        guard
            let url = URL(string: cleaned),
            let scheme = url.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        else { return nil }

        return url
    }
}
