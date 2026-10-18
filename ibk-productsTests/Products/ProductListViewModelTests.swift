//
//  ProductListViewModelTests.swift
//  ibk-productsTests
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Combine
import XCTest
@testable import ibk_products

@MainActor
final class ProductListViewModelTests: XCTestCase {
    // MARK: - Properties

    private let mockProducts: [Product] = .getMockData()

    // MARK: - First Page

    func testLoadFirstPageWithProductsSetsLoadedState() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)

        viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.products, Array(mockProducts.prefix(2)))
    }

    func testLoadFirstPageRequestsFirstPageWithPageSize() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)

        viewModel.loadFirstPage()

        XCTAssertEqual(repository.requests.count, 1)
        XCTAssertEqual(repository.requests.first?.offset, 0)
        XCTAssertEqual(repository.requests.first?.limit, 2)
    }

    func testLoadFirstPageWithoutProductsSetsEmptyState() {
        let viewModel = makeViewModel(repository: makeRepository(products: []))

        viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.state, .empty)
        XCTAssertTrue(viewModel.products.isEmpty)
    }

    func testLoadFirstPageWithErrorSetsErrorState() {
        let repository = makeRepository(products: mockProducts)
        repository.error = URLError(.notConnectedToInternet)
        let viewModel = makeViewModel(repository: repository)

        viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.state, .error)
        XCTAssertTrue(viewModel.products.isEmpty)
    }

    func testLoadFirstPageAfterErrorLoadsProducts() {
        let repository = makeRepository(products: mockProducts)
        repository.error = URLError(.notConnectedToInternet)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()

        repository.error = nil
        viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.products, Array(mockProducts.prefix(2)))
    }

    func testLoadFirstPageWhileLoadingDoesNotRequestAgain() {
        let repository = makeRepository(products: mockProducts)
        repository.pendingResponse = PassthroughSubject()
        let viewModel = makeViewModel(repository: repository)

        viewModel.loadFirstPage()
        viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.state, .loading)
        XCTAssertEqual(repository.requests.count, 1)
    }

    // MARK: - Pagination

    func testLoadNextPageIfNeededAppendsNextPage() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()

        viewModel.loadNextPageIfNeeded(currentIndex: 1)

        XCTAssertEqual(viewModel.products, mockProducts)
        XCTAssertEqual(repository.requests.last?.offset, 2)
        XCTAssertEqual(repository.requests.last?.limit, 2)
    }

    func testLoadNextPageIfNeededAfterLastPageDoesNotRequest() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()
        viewModel.loadNextPageIfNeeded(currentIndex: 1)

        viewModel.loadNextPageIfNeeded(currentIndex: 2)

        XCTAssertEqual(repository.requests.count, 2)
        XCTAssertEqual(viewModel.products, mockProducts)
    }

    func testLoadNextPageIfNeededShowsIndicatorWhileLoading() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()
        let pendingResponse = PassthroughSubject<[Product], Error>()
        repository.pendingResponse = pendingResponse

        viewModel.loadNextPageIfNeeded(currentIndex: 1)
        XCTAssertTrue(viewModel.isLoadingNextPage)

        pendingResponse.send([mockProducts[2]])
        pendingResponse.send(completion: .finished)
        XCTAssertFalse(viewModel.isLoadingNextPage)
    }

    func testLoadNextPageIfNeededWithErrorKeepsProductsAndRetriesSameOffset() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()

        repository.error = URLError(.timedOut)
        viewModel.loadNextPageIfNeeded(currentIndex: 1)

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.products, Array(mockProducts.prefix(2)))
        XCTAssertFalse(viewModel.isLoadingNextPage)

        repository.error = nil
        viewModel.loadNextPageIfNeeded(currentIndex: 1)

        XCTAssertEqual(repository.requests.last?.offset, 2)
        XCTAssertEqual(viewModel.products, mockProducts)
    }

    func testLoadNextPageIfNeededSkipsProductsAlreadyShown() {
        let duplicated = [mockProducts[0], mockProducts[1], mockProducts[1], mockProducts[2]]
        let repository = makeRepository(products: duplicated)
        let viewModel = makeViewModel(repository: repository)
        viewModel.loadFirstPage()

        viewModel.loadNextPageIfNeeded(currentIndex: 1)

        XCTAssertEqual(viewModel.products, mockProducts)
    }

    // MARK: - Initial Products

    func testInitWithProductsStartsLoadedWithoutFetching() {
        let repository = makeRepository(products: mockProducts)
        let viewModel = makeViewModel(repository: repository, products: mockProducts)

        viewModel.loadFirstPageIfNeeded()
        viewModel.loadNextPageIfNeeded(currentIndex: 2)

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.products, mockProducts)
        XCTAssertTrue(repository.requests.isEmpty)
    }

    // MARK: - Selection

    func testSelectProductCallsOnProductSelected() {
        let viewModel = makeViewModel(repository: makeRepository(products: mockProducts))
        viewModel.loadFirstPage()
        var selectedProduct: Product?
        viewModel.onProductSelected = { selectedProduct = $0 }

        viewModel.selectProduct(at: 1)

        XCTAssertEqual(selectedProduct, mockProducts[1])
    }

    func testSelectProductOutOfRangeDoesNotCallOnProductSelected() {
        let viewModel = makeViewModel(repository: makeRepository(products: mockProducts))
        viewModel.loadFirstPage()
        var selectedProduct: Product?
        viewModel.onProductSelected = { selectedProduct = $0 }

        viewModel.selectProduct(at: 10)

        XCTAssertNil(selectedProduct)
    }

    // MARK: - Private Methods

    private func makeRepository(products: [Product]) -> MockProductRepository {
        let repository = MockProductRepository()
        repository.products = products
        return repository
    }

    private func makeViewModel(
        repository: MockProductRepository,
        products: [Product] = []
    ) -> ProductListViewModel {
        .make(repository: repository, pageSize: 2, products: products)
    }
}
