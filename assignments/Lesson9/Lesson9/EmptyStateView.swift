//
//  Untitled.swift
//  Lesson9
//
//  Created by Timur Minkhatov on 29.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }
}
