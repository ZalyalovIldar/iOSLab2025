//
//  ErrorStateView.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 06.11.2025.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var onRetry: (() -> Void)? 
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            VStack(spacing: 8) {
                Text("Error")
                    .font(.title2)
                    .bold()
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let onRetry = onRetry {
                Button(action: onRetry) {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.headline)
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 200)
        .padding()
    }
}

#Preview {
    VStack(spacing: 40) {
        ErrorStateView(
            message: "Failed to load recipes",
            onRetry: {
                print("Retry tapped")
            }
        )
    }
}
