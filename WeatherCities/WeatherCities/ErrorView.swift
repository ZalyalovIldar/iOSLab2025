//
//  ErrorView.swift.swift
//  WeatherCities
//
//  Created by Artur Bagautdinov on 28.12.2025.
//

import SwiftUI

struct ErrorView: View {
    
    let message: String
    var onRetry: () -> Void

    var body: some View {
        
        VStack(spacing: 10) {
            
            Text(message)
                .font(.headline)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
}
