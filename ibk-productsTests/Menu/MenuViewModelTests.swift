//
//  MenuViewModelTests.swift
//  ibk-productsTests
//
//  Created by Gerardo Villegas on 18/10/26.
//

import XCTest
@testable import ibk_products

@MainActor
final class MenuViewModelTests: XCTestCase {
    // MARK: - Tests

    func testColorsContainWholePalette() {
        let viewModel = makeViewModel(store: MockPreferencesStore())

        XCTAssertEqual(viewModel.colors, TabBarColor.allCases)
    }

    func testSelectedColorDefaultsToStandard() {
        let viewModel = makeViewModel(store: MockPreferencesStore())

        XCTAssertEqual(viewModel.selectedColor, .standard)
    }

    func testSelectedColorRestoresSavedPreference() {
        let store = MockPreferencesStore()
        store.values[.tabBarColor] = TabBarColor.purple.rawValue

        let viewModel = makeViewModel(store: store)

        XCTAssertEqual(viewModel.selectedColor, .purple)
    }

    func testSelectedColorWithUnknownPreferenceFallsBackToStandard() {
        let store = MockPreferencesStore()
        store.values[.tabBarColor] = "unknown"

        let viewModel = makeViewModel(store: store)

        XCTAssertEqual(viewModel.selectedColor, .standard)
    }

    func testSelectColorUpdatesSelectionAndPersistsIt() throws {
        let store = MockPreferencesStore()
        let viewModel = makeViewModel(store: store)
        let index = try XCTUnwrap(viewModel.colors.firstIndex(of: .green))

        viewModel.selectColor(at: index)

        XCTAssertEqual(viewModel.selectedColor, .green)
        XCTAssertEqual(store.values[.tabBarColor], TabBarColor.green.rawValue)
    }

    func testSelectColorUpdatesSharedThemeService() throws {
        let themeService = ThemeService(preferencesStore: MockPreferencesStore())
        let viewModel = MenuViewModel.make(themeService: themeService)
        let index = try XCTUnwrap(viewModel.colors.firstIndex(of: .red))

        viewModel.selectColor(at: index)

        XCTAssertEqual(themeService.tabBarColor, .red)
    }

    func testSelectColorOutOfRangeKeepsSelection() {
        let store = MockPreferencesStore()
        let viewModel = makeViewModel(store: store)

        viewModel.selectColor(at: 99)

        XCTAssertEqual(viewModel.selectedColor, .standard)
        XCTAssertNil(store.values[.tabBarColor])
    }

    // MARK: - Private Methods

    private func makeViewModel(store: MockPreferencesStore) -> MenuViewModel {
        .make(themeService: ThemeService(preferencesStore: store))
    }
}
