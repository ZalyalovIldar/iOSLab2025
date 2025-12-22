//
//  RecipeService.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 05.11.2025.
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
                  title: "Pasta",
                  imageName: "pasta",
                  summary: "pasta with sauce",
                  category: "Main"),
            .init(id: .init(),
                  title: "Lapsha",
                  imageName: "lapsha",
                  summary: "soup with chicken",
                  category: "Starter"),
            .init(id: .init(),
                  title: "Caesar",
                  imageName: "salad",
                  summary: "Salad with souse and chiken",
                  category: "Side"),
            .init(id: .init(),
                  title: "Charlotte",
                  imageName: "dessert",
                  summary: "Dessert with apple",
                  category: "Sweet dishes"),
        ]
    }
}
