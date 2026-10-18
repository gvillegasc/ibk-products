//
//  PreferencesStore.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import Foundation

nonisolated enum PreferenceKey: String {
    case tabBarColor
}

nonisolated protocol PreferencesStore {
    func string(for key: PreferenceKey) -> String?
    func set(_ value: String?, for key: PreferenceKey)
}

nonisolated struct UserDefaultsPreferencesStore: PreferencesStore {
    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Initialization

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Methods

    func string(for key: PreferenceKey) -> String? {
        userDefaults.string(forKey: key.rawValue)
    }

    func set(_ value: String?, for key: PreferenceKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}
