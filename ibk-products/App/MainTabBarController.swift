//
//  MainTabBarController.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Combine
import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    private let themeService: ThemeService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(themeService: ThemeService) {
        self.themeService = themeService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        traitOverrides.horizontalSizeClass = .compact
        bindTheme()
    }

    // MARK: - Setup

    private func bindTheme() {
        themeService.$tabBarColor
            .sink { [weak self] tabBarColor in
                self?.apply(tabBarColor)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func apply(_ tabBarColor: TabBarColor) {
        let appearance = UITabBarAppearance()

        if let backgroundColor = tabBarColor.color {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor

            let itemAppearance = UITabBarItemAppearance()
            let unselectedColor = UIColor.white.withAlphaComponent(0.7)
            itemAppearance.normal.iconColor = unselectedColor
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
            itemAppearance.selected.iconColor = .white
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
        } else {
            appearance.configureWithDefaultBackground()
        }

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
