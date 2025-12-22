//
//  RecipeDetailView.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 08.11.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let viewModel: RecipesViewModel
    
    @State private var showEdit = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                recipeHeroImage()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .bold()
                        
                    HStack {
                        Label(recipe.category, systemImage: "tag.fill")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                            
                        Spacer()
                            
                        Text(recipe.dateAdded, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    Divider()
                    
                    if !recipe.summary.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.title2)
                                .bold()
                            
                            Text(recipe.summary)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("No description available")
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .italic()
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showEdit = true
                    } label: {
                        Label("Edit Recipe", systemImage: "pencil")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete Recipe", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            AddRecipeSheet(
                editingRecipe: recipe,
                onAdd: { _ in },
                onUpdate: { updatedRecipe in
                    viewModel.update(updatedRecipe)
                }
            )
            .presentationDetents([.medium, .large])
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.remove(recipe)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(recipe.title)\"? This action cannot be undone.")
        }
    }
    
    @ViewBuilder
    private func recipeHeroImage() -> some View {
        Group {
            if !recipe.imageName.isEmpty, let uiImage = UIImage(named: recipe.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            } else {
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 300)
                    
                    VStack(spacing: 16) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        
                        Text("No Image Available")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
