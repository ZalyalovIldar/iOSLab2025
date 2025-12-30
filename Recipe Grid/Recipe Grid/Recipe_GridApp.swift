//
//  Recipe_GridApp.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import SwiftUI

@main
struct Recipe_GridApp: App {
    @State var viewModel = RecipeViewModel(recipeService: MockRecipeService())
    var body: some Scene {
        WindowGroup {
            RecipeView(viewModel: viewModel)
        }
    }
}
