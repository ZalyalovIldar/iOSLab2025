//
//  RecipeDetailView.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    private let availableImages = ["balesh", "chak-chak", "kystyby", "triangle"]
    
    private var hasImage: Bool {
        availableImages.contains(recipe.imageName)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Large image
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
                            .frame(maxHeight: 200)
                    }
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(Color.gray.opacity(0.1))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Label(recipe.category, systemImage: "tag.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    
                    Divider()
                    
                    if !recipe.summary.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(recipe.summary)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

