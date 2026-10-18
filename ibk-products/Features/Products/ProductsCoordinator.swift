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

    // MARK: - Initializer

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    // MARK: - Start

    func start() {
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "Productos"),
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        navigationController.navigationBar.prefersLargeTitles = true

        let placeholderViewController = UIViewController()
        placeholderViewController.title = String(localized: "Productos")
        placeholderViewController.view.backgroundColor = .systemBackground

        navigationController.setViewControllers([placeholderViewController], animated: false)
    }
}
