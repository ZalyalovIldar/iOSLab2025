//
//  RecipeCardView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import SwiftUI

struct RecipeCardView: View {
    
    let recipe: Recipe
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {

            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.1),
                                Color.purple.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.25), radius: 6, x: 0, y: 4)
                    .padding(10)

                cardImage
                    .padding(18)
            }
            .frame(height: 100)
            
            Text(recipe.title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .padding(.bottom, 2)
            
            if !recipe.summary.isEmpty {
                
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 2)
            }
            
            Text(recipe.category)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.blue.opacity(0.1))
                )
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 3)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
        )
    }
    
    @ViewBuilder
    private var cardImage: some View {
        
        switch recipe.imageType {
            
        case .symbol:
            if recipe.imageName != "" {
                Image(systemName: recipe.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 120, maxHeight: 70)
            } else {
                PlaceholderImageView()
                    .frame(maxWidth: 120, maxHeight: 70)
            }
            
        case .photo:
            if let uiImage = RecipeImageStorage.shared.load(fileName: recipe.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 120, maxHeight: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
        case .none:
            PlaceholderImageView()
                .frame(maxWidth: 120, maxHeight: 70)
        }
    }
}

#Preview {
    RecipeCardView(recipe: Recipe(title: "Spaghetti", imageName: "", summary: "Classic Italian pasta dish with tomato sauce.", category: "Main", imageType: .symbol))
}
