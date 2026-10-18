//
//  MockPreferencesStore.swift
//  ibk-productsTests
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Foundation
@testable import ibk_products

final class MockPreferencesStore: PreferencesStore {
    // MARK: - Properties

    var values: [PreferenceKey: String] = [:]

    // MARK: - Public Methods

    func string(for key: PreferenceKey) -> String? {
        values[key]
    }

    func set(_ value: String?, for key: PreferenceKey) {
        values[key] = value
    }
}
