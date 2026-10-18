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

// MARK: - Extensions

nonisolated extension Array<Product> {
    static func getMockData() -> [Product] {
        [
            Product(
                id: 1,
                title: "Classic Red Pullover Hoodie",
                price: 10,
                description: "Elevate your casual wardrobe with our Classic Red Pullover Hoodie.",
                categoryName: "Clothes",
                imageURLs: []
            ),
            Product(
                id: 2,
                title: "Classic Heather Gray Hoodie",
                price: 69,
                description: "Stay cozy and stylish with our Classic Heather Gray Hoodie.",
                categoryName: "Clothes",
                imageURLs: []
            ),
            Product(
                id: 3,
                title: "Classic Navy Blue Baseball Cap",
                price: 61,
                description: "Top off your casual look with our Classic Navy Blue Baseball Cap.",
                categoryName: "Clothes",
                imageURLs: []
            ),
        ]
    }
}

nonisolated extension Product {
    static func getMockData() -> Product {
        Product(
            id: 1,
            title: "Classic Red Pullover Hoodie",
            price: 10,
            description: """
                Elevate your casual wardrobe with our Classic Red Pullover Hoodie. Crafted with a soft cotton \
                blend for ultimate comfort, this vibrant red hoodie features a kangaroo pocket, adjustable \
                drawstring hood, and ribbed cuffs for a snug fit.
                """,
            categoryName: "Clothes",
            imageURLs: [URL(string: "https://i.imgur.com/1twoaDy.jpeg")].compactMap { $0 }
        )
    }
}
