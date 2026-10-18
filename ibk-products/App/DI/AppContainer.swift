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

    // MARK: - Initializer

    init(httpClient: any HTTPClient = URLSessionHTTPClient(baseURL: AppContainer.apiBaseURL)) {
        self.httpClient = httpClient
    }

    // MARK: - Configuration

    private static let apiBaseURL: URL = {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1") else {
            fatalError("Invalid API base URL")
        }
        return url
    }()
}
