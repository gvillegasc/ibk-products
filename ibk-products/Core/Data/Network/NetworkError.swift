//
//  NetworkError.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import Foundation

nonisolated enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(code: Int)
    case decoding
    case noConnection
    case requestFailed
}
