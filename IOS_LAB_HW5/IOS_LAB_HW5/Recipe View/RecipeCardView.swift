//
//  RecipeCardView.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//
import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение или placeholder
            if recipe.imageName.isEmpty {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Image(recipe.imageName)
                    .resizable() //растягиваемое изображение заполняет всю область
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
            }
            
            Text(recipe.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(recipe.category)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(recipe.summary)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.thinMaterial) //полупрозрачный фон
        .cornerRadius(12)
    }
}

