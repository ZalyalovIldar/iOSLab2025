//
//  Color.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 19.12.2025.
//

import SwiftUI

extension Color {
    
    static let backgroundColor = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.80, blue: 0.56),
            Color(red: 0.95, green: 0.54, blue: 0.33)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.11, green: 0.33, blue: 0.80),
            Color(red: 0.33, green: 0.58, blue: 1.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
