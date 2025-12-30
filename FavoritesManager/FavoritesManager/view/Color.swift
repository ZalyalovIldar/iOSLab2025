//
//  Color.swift
//  FavoritesManager
//
//  Created by Artur Bagautdinov on 30.12.2025.
//

import SwiftUI

extension Color {
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.blue.opacity(0.09),
            Color.purple.opacity(0.14)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let placeholderGradient = LinearGradient(
        colors: [
            Color.teal.opacity(0.12),
            Color.cyan.opacity(0.08)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
