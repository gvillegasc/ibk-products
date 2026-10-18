//
//  ProductsCoordinator.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import UIKit

final class ProductsCoordinator: Coordinator {
    // MARK: - Properties

    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let container: AppContainer

    // MARK: - Initialization

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    // MARK: - Public Methods

    func start() {
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "Productos"),
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        navigationController.navigationBar.prefersLargeTitles = true

        let viewModel = ProductListViewModel.make(repository: container.productRepository)
        viewModel.onProductSelected = { [weak self] product in
            self?.showDetail(for: product)
        }

        navigationController.setViewControllers([ProductListViewController(viewModel: viewModel)], animated: false)
    }

    // MARK: - Private Methods

    private func showDetail(for product: Product) {
        let placeholderViewController = UIViewController()
        placeholderViewController.title = product.title
        placeholderViewController.view.backgroundColor = .systemBackground
        placeholderViewController.navigationItem.largeTitleDisplayMode = .never

        navigationController.pushViewController(placeholderViewController, animated: true)
    }
}
