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
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.blue.opacity(0.12),
                                        Color.purple.opacity(0.1),
                                        Color.pink.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(
                                color: .purple.opacity(0.35),
                                radius: 12,
                                x: 0,
                                y: 8
                            )
                    )
                    .padding(.horizontal)
                    .padding(.top)

                Text(recipe.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                
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
                    .padding(.horizontal, 24)
                
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
                    .padding(.horizontal, 20)
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
