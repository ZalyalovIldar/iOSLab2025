//
//  RecipeCardView.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//
import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    private let availableImages = ["balesh", "chak-chak", "kystyby", "triangle"]
    
    private var hasImage: Bool {
        availableImages.contains(recipe.imageName)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if hasImage {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(maxHeight: 100)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(Color.gray.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(recipe.category)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                if !recipe.summary.isEmpty {
                    Text(recipe.summary)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
