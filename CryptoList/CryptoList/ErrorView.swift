//
//  ErrorView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 24.12.2025.
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
    }
}
