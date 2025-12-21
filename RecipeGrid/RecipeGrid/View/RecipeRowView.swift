//
//  RecipeRowView.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    private var folderName = "recipe_images"
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        VStack {
            ImageView(recipe: recipe, folderName: folderName)
            Text(recipe.title)
                .font(.title3.bold())
                .lineLimit(1)
                .padding(.vertical)
                .padding(.horizontal, 2)
        }
        .foregroundStyle(.white)
        .padding()
        .glassEffect(.clear, in: .rect(cornerRadius: 25))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecipeRowView(recipe: Recipe.mockRecipes.first ?? Recipe(title: "", imageName: "", summary: "", category: FoodCategory.appetizer))
    }
}
