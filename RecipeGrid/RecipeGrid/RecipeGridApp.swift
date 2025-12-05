//
//  RecipeGridApp.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import SwiftUI

@main
struct RecipeGridApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesView()
                .preferredColorScheme(.dark)
        }
    }
}
