//
//  ThemeService.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Combine
import Foundation

final class ThemeService {
    // MARK: - Properties

    @Published private(set) var tabBarColor: TabBarColor

    private let preferencesStore: any PreferencesStore

    // MARK: - Initialization

    init(preferencesStore: any PreferencesStore) {
        self.preferencesStore = preferencesStore
        self.tabBarColor = preferencesStore.string(for: .tabBarColor).flatMap(TabBarColor.init(rawValue:)) ?? .standard
    }

    nonisolated deinit {}

    // MARK: - Public Methods

    func setTabBarColor(_ color: TabBarColor) {
        guard color != tabBarColor else { return }

        preferencesStore.set(color.rawValue, for: .tabBarColor)
        tabBarColor = color
    }
}
