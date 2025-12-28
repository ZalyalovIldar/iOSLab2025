//
//  EmptyStateView.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    
    let title: String
    let subtitle: String
    var onRetry: () -> Void

    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: "cloud")
                .font(.system(size: 34))
            
            Text(title).font(.headline)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
