//
//  RecipeViewModel.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import Foundation
import SwiftUI

@Observable
final class RecipeViewModel {
    private var userDefaultsKey = "recipes"
    
    var recipes: [Recipe] = []
    var searchText = ""
    var selectedCategory = FoodCategory.main
    var isSortedByTitle = false
    
    var recipesForCategory: [Recipe] {
        recipes.filter { $0.category == selectedCategory }
    }
    
    var filteredRecipes: [Recipe] {
        var recipes = recipesForCategory
        
        if !searchText.isEmpty {
            recipes = recipesForCategory.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.category.rawValue.localizedCaseInsensitiveContains(searchText) }
        }
        if isSortedByTitle {
            recipes = sortByTitle()
        }
        return recipes
    }
    
    init() {
        getRecipes()
    }
    
    func getRecipes() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) else { return }
        self.recipes = recipes
    }
    
    func add(title: String, summary: String, imageName: String, category: FoodCategory) {
        let recipe = Recipe(title: title, imageName: imageName, summary: summary, category: category)
        recipes.append(recipe)
        save()
    }
    
    func update(id: UUID, title: String, summary: String, imageName: String, category: FoodCategory) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            let recipe = Recipe(id: id, title: title, imageName: imageName, summary: summary, category: category)
            recipes[index] = recipe
            save()
        }
    }
    
    func delete(id: UUID) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes.remove(at: index)
            save()
        }
    }
    
    func sortByTitle() -> [Recipe] {
        recipesForCategory.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
