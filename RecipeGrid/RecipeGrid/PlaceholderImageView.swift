//
//  PlaceholderImageView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 07.12.2025.
//

import SwiftUI

struct PlaceholderImageView: View {
    var body: some View {
        
        VStack(spacing: 8) {
            Image(systemName: "photo")
                .font(.system(size: 30))
                .foregroundColor(.gray)
            Text("No image")
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding()
    }
}

#Preview {
    PlaceholderImageView()
}
