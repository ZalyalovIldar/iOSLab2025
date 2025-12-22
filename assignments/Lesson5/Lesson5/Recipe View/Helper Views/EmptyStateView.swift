//
//  EmptyStateView.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 06.11.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 200)
        .padding()
    }
}

#Preview {
    VStack(spacing: 40) {
        EmptyStateView(
            title: "No recipes",
            subtitle: "Add your first recipe here"
        )
    }
}
