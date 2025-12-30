//
//  RecipeService.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import Foundation

protocol RecipeService {
    func obtainRecipes() async throws -> [Recipe]
}


struct MockRecipeService: RecipeService {
    
    func obtainRecipes() async throws -> [Recipe] {
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            .init(id: .init(),
                  title: "Balesh",
                  imageName: "balesh",
                  summary: "meal",
                  category: "Main course"),
            .init(id: .init(),
                  title: "Triangle",
                  imageName: "triangle",
                  summary: "bakery with meat and potatoes",
                  category: "bakery"),
            .init(id: .init(),
                  title: "Chak-chak",
                  imageName: "chak-chak",
                  summary: "sweet pastries",
                  category: "dessert"),
            .init(id: .init(),
                  title: "Kystyby",
                  imageName: "kystyby",
                  summary: "pita bread with mashed potatoes",
                  category: "Main course")

        ]
    }
}
