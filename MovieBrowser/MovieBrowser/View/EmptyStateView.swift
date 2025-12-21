//
//  EmptyStateView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 20.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 60))
                .foregroundStyle(.black.opacity(0.7))
                .padding(.bottom, 8)
            
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.black)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.black.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        title: "No movies yet",
        message: "Add your first movie to start filling your collection.",
        buttonTitle: "Add movie") {}
    
}
