//
//  Lesson5App.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 05.11.2025.
//

import SwiftUI

@main
struct Lesson5App: App {
    @State var viewModel = RecipesViewModel(recipeService: MockRecipeService())
    
    var body: some Scene {
        WindowGroup {
            RecipesView(viewModel: viewModel)
        }
    }
}
