//
//  RecipeViewModel.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import Foundation

@Observable
final class RecipeViewModel {
    
    enum ScreenState {
        case loading
        case error(String)
        case empty
        case content([Recipe])
    }
    
    enum SortOption: String, CaseIterable {
        case none = "None"
        case alphabetically = "Alphabetically"
        case byCategory = "By Category"
    }
    
    private var items: [Recipe] = []
    
    private var isLoading = false
    private var errorString: String?
    var searchText: String = ""
    var selectedCategory: String?
    var sortOption: SortOption = .none
    private let recipeService: RecipeService
    
    private let userDefaultsKey = "savedRecipes"
    
    private var allCategories: [String] {
        Array(Set(items.map { $0.category })).sorted()
    }
    
    var availableCategories: [String] {
        ["All"] + allCategories
    }
    
    private var filteredItems: [Recipe] {
        var result = items
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedCategory = selectedCategory, selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        switch sortOption {
        case .none:
            break
        case .alphabetically:
            result = result.sorted { $0.title < $1.title }
        case .byCategory:
            result = result.sorted { $0.category < $1.category }
        }
        
        return result
    }
    
    var screenState: ScreenState {
        if isLoading { return .loading }
        if let error = errorString { return .error(error) }
   
        return filteredItems.isEmpty ? .empty : .content(filteredItems)
    }
    
    init(items: [Recipe] = [], recipeService: RecipeService) {
        self.recipeService = recipeService
        loadFromUserDefaults()
    }
    
    func loadRecipes() async {
        guard items.isEmpty, !isLoading  else { return }
        isLoading = true
        
        defer { isLoading = false }
        do {
            let loadedRecipes = try await recipeService.obtainRecipes()
            if items.isEmpty {
                items = loadedRecipes
                saveToUserDefaults()
            }
            errorString = nil
        } catch {
            errorString = "Failed to load recipes"
            isLoading = false
        }
    }
    
    func add(_ recipe: Recipe) {
        items.insert(recipe, at: 0)
        saveToUserDefaults()
    }
    
    func update(_ recipe: Recipe) {
        guard let index = items.firstIndex(where: { $0.id == recipe.id }) else { return }
        items[index] = recipe
        saveToUserDefaults()
    }
    
    func remove(_ recipe: Recipe) {
        guard let index = items.firstIndex(of: recipe) else { return }
        items.remove(at: index)
        saveToUserDefaults()
    }
        
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            items = decoded
        }
    }
}
