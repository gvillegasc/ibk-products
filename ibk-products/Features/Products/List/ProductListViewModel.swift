//
//  ProductListViewModel.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import CombineExt
import Foundation

final class ProductListViewModel {
    enum State: Equatable {
        case loading
        case loaded
        case empty
        case error
    }

    // MARK: - Properties

    @Published private(set) var state: State = .loading
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoadingNextPage = false

    var onProductSelected: ((Product) -> Void)?

    private let repository: any ProductRepository
    private let pageSize: Int
    private let prefetchThreshold = 5

    private var nextOffset = 0
    private var hasMorePages = true
    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(repository: any ProductRepository, pageSize: Int = 20, products: [Product] = []) {
        self.repository = repository
        self.pageSize = pageSize
        self.products = products
        self.state = products.isEmpty ? .loading : .loaded
        self.hasMorePages = products.isEmpty
    }

    // MARK: - Public Methods

    func loadFirstPageIfNeeded() {
        guard products.isEmpty else { return }
        loadFirstPage()
    }

    func loadFirstPage() {
        guard !isLoading else { return }

        products = []
        nextOffset = 0
        hasMorePages = true
        state = .loading
        loadPage()
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        guard
            state == .loaded,
            hasMorePages,
            !isLoading,
            currentIndex >= products.count - prefetchThreshold
        else { return }

        isLoadingNextPage = true
        loadPage()
    }

    func selectProduct(at index: Int) {
        guard products.indices.contains(index) else { return }
        onProductSelected?(products[index])
    }

    // MARK: - Private Methods

    private func loadPage() {
        isLoading = true

        repository
            .fetchProducts(offset: nextOffset, limit: pageSize)
            .mapToResult()
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let page):
                    append(page)
                case .failure:
                    handleFailure()
                }
                isLoading = false
                isLoadingNextPage = false
            }
            .store(in: &cancellables)
    }

    private func append(_ page: [Product]) {
        nextOffset += page.count
        hasMorePages = page.count == pageSize

        let shownIDs = Set(products.map(\.id))
        products += page.filter { !shownIDs.contains($0.id) }
        state = products.isEmpty ? .empty : .loaded
    }

    private func handleFailure() {
        if products.isEmpty {
            state = .error
        }
    }
}

extension ProductListViewModel {
    static func make(
        repository: any ProductRepository = AppContainer().productRepository,
        pageSize: Int = 20,
        products: [Product] = []
    ) -> ProductListViewModel {
        .init(
            repository: repository,
            pageSize: pageSize,
            products: products
        )
    }
}
