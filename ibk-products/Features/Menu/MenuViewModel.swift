//
//  MenuViewModel.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Combine
import Foundation

final class MenuViewModel {
    // MARK: - Properties

    let colors = TabBarColor.allCases

    @Published private(set) var selectedColor: TabBarColor

    private let themeService: ThemeService

    // MARK: - Initialization

    init(themeService: ThemeService) {
        self.themeService = themeService
        self.selectedColor = themeService.tabBarColor
        themeService.$tabBarColor.assign(to: &$selectedColor)
    }

    // MARK: - Public Methods

    func selectColor(at index: Int) {
        guard colors.indices.contains(index) else { return }
        themeService.setTabBarColor(colors[index])
    }
}

extension MenuViewModel {
    static func make(themeService: ThemeService = AppContainer().themeService) -> MenuViewModel {
        .init(themeService: themeService)
    }
}
