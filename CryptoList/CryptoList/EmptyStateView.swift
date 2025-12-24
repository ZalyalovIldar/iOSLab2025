//
//  EmptyStateView.swift
//  CryptoList
//
//  Created by Artur Bagautdinov on 24.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        
        VStack(spacing: 10) {
            Image(systemName: "person.3")
                .font(.system(size: 34))
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
#Preview {
    
}
