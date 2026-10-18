//
//  AppContainer.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Foundation

final class AppContainer {
    // MARK: - Properties

    let httpClient: any HTTPClient
    let productRepository: any ProductRepository
    let themeService: ThemeService

    private static let apiBaseURL: URL = {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1") else {
            fatalError("Invalid API base URL")
        }
        return url
    }()

    // MARK: - Initialization

    init(
        httpClient: any HTTPClient = URLSessionHTTPClient(baseURL: AppContainer.apiBaseURL),
        preferencesStore: any PreferencesStore = UserDefaultsPreferencesStore()
    ) {
        self.httpClient = httpClient
        self.productRepository = RemoteProductRepository(httpClient: httpClient)
        self.themeService = ThemeService(preferencesStore: preferencesStore)
    }
}
