//
//  RecipeDetailView.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss)
    private var dismiss
    @Bindable var recipeViewModel: RecipeViewModel
    
    @State private var isEditSheetShown = false
    private let folderName = "recipe_images"
    
    let recipeId: UUID

    var recipe: Recipe? {
        recipeViewModel.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        if let recipe {
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.title.bold())
                        .padding()
                    ImageView(recipe: recipe, folderName: folderName)
                        .padding(.horizontal)
                
                    Text(recipe.summary)
                        .padding()
                }
                .foregroundStyle(.white)
            }
            .sheet(isPresented: $isEditSheetShown, content: {
                CreateRecipeView(recipeViewModel: recipeViewModel, recipe: recipe)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditSheetShown = true
                    } label: {
                        Text("Edit")
                    }
                }
                ToolbarSpacer(placement: .bottomBar)
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        recipeViewModel.delete(id: recipe.id)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
        }
    }
}
