//
//  ReciepesViewModel.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import Foundation
import SwiftUI

@Observable
final class RecipesViewModel {
    
    enum SortOption {
        case none
        case alphabetical
        case category
    }
    
    private let storageKey = "recipes_storage"
    
    var selectedCategory: String?
    
    var sortOption: SortOption = .none
    
    var items: [Recipe] = [] {
        didSet { save() }
    }
    
    init() {
        load()
    }
    
    var categories: [String] {
        let set = Set(items.map { $0.category })
        return Array(set).sorted()
    }
    
    var searchText: String = ""
    
    var lastAddedRecipeID: UUID?
    
    func add(_ recipe: Recipe) {
        items.insert(recipe, at: 0)
        lastAddedRecipeID = recipe.id
    }
    
    func remove(_ recipe: Recipe) {

        if recipe.imageType == .photo, !recipe.imageName.isEmpty {
            RecipeImageStorage.shared.delete(fileName: recipe.imageName)
        }
        
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
        
        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory }
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
    
    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? decoder.decode([Recipe].self, from: data) {
            self.items = decoded
        } else {
            self.items = []
        }
        self.sortOption = .none
        self.selectedCategory = nil
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    func binding(for id: UUID) -> Binding<Recipe> {
        Binding(
            get: {
                self.items.first(where: { $0.id == id }) ?? Recipe.empty
            },
            set: { updated in
                if let ind = self.items.firstIndex(where: { $0.id == id }) {
                    self.items[ind] = updated
                }
            }
        )
    }
}
