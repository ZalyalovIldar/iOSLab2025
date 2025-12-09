//
//  RecipeDetailView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 09.12.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @Binding var recipe: Recipe
    
    @State private var showEditSheet = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 10) {
                
                RecipeImageView(recipe: recipe)
                    .frame(maxWidth: .infinity)
                    .frame(height: 260)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray6))
                            .shadow(radius: 4)
                    )
                    .padding()
                
                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
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
                    .padding(.horizontal)
                
                if !recipe.summary.isEmpty {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Summary")
                            .font(.headline)
                        
                        Text(recipe.summary)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 20)
            }
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            RecipeEditView(recipe: $recipe)
        }
    }
}

#Preview {
    @Previewable @State var previewRecipe = Recipe(
        title: "Sample Recipe",
        imageName: "fork.knife",
        summary: "A delicious sample recipe for preview.",
        category: "Preview",
        imageType: .symbol
    )
    return RecipeDetailView(recipe: $previewRecipe)
}
