//
//  MenuCoordinator.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import UIKit

final class MenuCoordinator: Coordinator {
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
            title: String(localized: "Menú"),
            image: UIImage(systemName: "line.3.horizontal"),
            selectedImage: nil
        )
        navigationController.navigationBar.prefersLargeTitles = true

        let placeholderViewController = UIViewController()
        placeholderViewController.title = String(localized: "Menú")
        placeholderViewController.view.backgroundColor = .systemBackground

        navigationController.setViewControllers([placeholderViewController], animated: false)
    }
}
