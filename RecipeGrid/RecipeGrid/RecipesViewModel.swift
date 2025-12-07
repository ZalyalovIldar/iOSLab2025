//
//  ReciepesViewModel.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import Foundation

@Observable
final class RecipesViewModel {
    
    enum SortOption {
        case none
        case alphabetical
        case category
    }
    
    var sortOption: SortOption = .none
    
    var items: [Recipe] = [
        
        Recipe(
            title: "Spaghetti Carbonara",
            imageName: "fork.knife",
            summary: "Creamy pasta with pancetta and parmesan.",
            category: "Main",
            imageType: .symbol
        ),
        Recipe(
            title: "Apple Pie",
            imageName: "applelogo",
            summary: "Classic dessert with spiced apples.",
            category: "Dessert",
            imageType: .symbol
        ),
        Recipe(
            title: "Caesar Salad",
            imageName: "leaf",
            summary: "Romaine lettuce with Caesar dressing and croutons.",
            category: "Salad",
            imageType: .symbol
        ),
        Recipe(
            title: "Tomato Soup",
            imageName: "drop.fill",
            summary: "Smooth tomato soup with a hint of basil.",
            category: "Soup",
            imageType: .symbol
        ),
        Recipe(
            title: "Grilled Cheese",
            imageName: "flame.fill",
            summary: "Buttery grilled bread with melted cheese.",
            category: "Snack",
            imageType: .symbol
        ),
        Recipe(
            title: "Chicken Curry",
            imageName: "hare.fill",
            summary: "Savory chicken in a spicy curry sauce.",
            category: "Main",
            imageType: .symbol
        ),
        Recipe(
            title: "Pancakes",
            imageName: "circle.grid.hex",
            summary: "Fluffy pancakes with maple syrup.",
            category: "Breakfast",
            imageType: .symbol
        ),
        Recipe(
            title: "Avocado Toast",
            imageName: "avocado",
            summary: "Toasted bread topped with smashed avocado.",
            category: "Breakfast",
            imageType: .symbol
        ),
        Recipe(
            title: "Chocolate Mousse",
            imageName: "cube.fill",
            summary: "Rich and airy chocolate dessert.",
            category: "Dessert",
            imageType: .symbol
        ),
        Recipe(
            title: "Greek Salad",
            imageName: "sparkles",
            summary: "Crisp veggies, feta, and olives.",
            category: "Salad",
            imageType: .symbol
        ),
    ]
    var searchText: String = ""
    
    func add(_ recipe: Recipe) {
        items.insert(recipe, at: 0)
    }
    
    func remove(_ recipe: Recipe) {
    guard let index = items.firstIndex(where: { $0.id == recipe.id }) else { return }
    items.remove(at: index)
}
    
    var filteredItems: [Recipe] {
        var result = items
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        switch sortOption {
        case .none:
            return result
        case .alphabetical:
            return result.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .category:
            return result.sorted { $0.category.localizedCompare($1.category) == .orderedAscending }
        }
    }
    
    func removeAll() {
        items.removeAll()
    }
}
