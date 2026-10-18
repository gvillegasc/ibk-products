//
//  TabBarColor.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 18/10/26.
//

import UIKit

enum TabBarColor: String, CaseIterable {
    case standard
    case blue
    case green
    case orange
    case purple
    case red

    // MARK: - Properties

    var title: String {
        switch self {
        case .standard:
            return String(localized: "Predeterminado")
        case .blue:
            return String(localized: "Azul")
        case .green:
            return String(localized: "Verde")
        case .orange:
            return String(localized: "Naranja")
        case .purple:
            return String(localized: "Morado")
        case .red:
            return String(localized: "Rojo")
        }
    }

    var color: UIColor? {
        switch self {
        case .standard:
            return nil
        case .blue:
            return .systemBlue
        case .green:
            return .systemGreen
        case .orange:
            return .systemOrange
        case .purple:
            return .systemPurple
        case .red:
            return .systemRed
        }
    }
}
