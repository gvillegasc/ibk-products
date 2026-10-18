//
//  ProductDetailViewModelTests.swift
//  ibk-productsTests
//
//  Created by Gerardo Villegas on 18/10/26.
//

import XCTest
@testable import ibk_products

@MainActor
final class ProductDetailViewModelTests: XCTestCase {
    // MARK: - Properties

    private let product: Product = .getMockData()

    // MARK: - Tests

    func testInitExposesProductValues() {
        let viewModel = ProductDetailViewModel.make(product: product)

        XCTAssertEqual(viewModel.title, product.title)
        XCTAssertEqual(viewModel.categoryName, product.categoryName)
        XCTAssertEqual(viewModel.description, product.description)
    }

    func testInitFormatsPriceInDollars() {
        let viewModel = ProductDetailViewModel.make(product: product)

        XCTAssertEqual(viewModel.formattedPrice, product.price.formatted(.currency(code: "USD")))
        XCTAssertTrue(viewModel.formattedPrice.contains("10"))
    }

    func testInitUsesFirstImage() {
        let viewModel = ProductDetailViewModel.make(product: product)

        XCTAssertEqual(viewModel.imageURL, product.imageURLs.first)
        XCTAssertNotNil(viewModel.imageURL)
    }

    func testInitWithoutImagesHasNoImageURL() {
        let productWithoutImages = Product(
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            categoryName: product.categoryName,
            imageURLs: []
        )

        let viewModel = ProductDetailViewModel.make(product: productWithoutImages)

        XCTAssertNil(viewModel.imageURL)
    }
}
