//
//  RecipeDetailView.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//
import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if recipe.imageName.isEmpty {
                    Image(systemName: "photo")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                } else {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300) //обрезаем изображение по высоте
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(recipe.category)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text(recipe.summary)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding()
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline) //заголовок в компактном режиме
    }
}
