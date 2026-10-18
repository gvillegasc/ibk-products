//
//  AppCoordinator.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties

    var childCoordinators: [Coordinator] = []

    private let window: UIWindow
    private let container: AppContainer

    // MARK: - Initializer

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
    }

    // MARK: - Start

    func start() {
        let productsNavigationController = UINavigationController()
        let menuNavigationController = UINavigationController()

        childCoordinators = [
            ProductsCoordinator(navigationController: productsNavigationController, container: container),
            MenuCoordinator(navigationController: menuNavigationController, container: container),
        ]
        childCoordinators.forEach { $0.start() }

        let tabBarController = MainTabBarController()
        tabBarController.setViewControllers(
            [productsNavigationController, menuNavigationController],
            animated: false
        )

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
