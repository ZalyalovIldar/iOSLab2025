//
//  RecipesViewModel.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 05.11.2025.
//

import Foundation

@Observable
final class RecipesViewModel {
    
    enum ScreenState {
        case loading
        case error(String)
        case empty
        case content([Recipe])
    }
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case category = "Category"
        case dateAdded = "Date Added"
    }
    
    private var items: [Recipe] = []
    
    private var isLoading = false
    private var errorString: String?
    var searchText: String = ""
    var sortOption: SortOption = .dateAdded
    var selectedCategory: String?
    
    private let recipeService: RecipeService
    private let recipesKey = "saved_recipes"
    private var loadingTask: Task<Void, Never>?
    
    private var sortedItems: [Recipe] {
        switch sortOption {
        case .title:
            return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .category:
            return items.sorted {
                if $0.category == $1.category {
                    return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                }
                return $0.category.localizedCaseInsensitiveCompare($1.category) == .orderedAscending
            }
        case .dateAdded:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    private var categorizedItems: [Recipe] {
        guard let category = selectedCategory else { return sortedItems }
        return sortedItems.filter { $0.category == category }
    }
    
    private var filteredItems: [Recipe] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedSearch.isEmpty else { return categorizedItems }
        
        let lowercasedSearch = trimmedSearch.lowercased()
        
        return categorizedItems.filter { recipe in
            recipe.title.lowercased().contains(lowercasedSearch) ||
            recipe.category.lowercased().contains(lowercasedSearch) ||
            recipe.summary.lowercased().contains(lowercasedSearch)
        }
    }
    
    var screenState: ScreenState {
        if isLoading { return .loading }
        if let errorString { return .error(errorString) }
        
        return filteredItems.isEmpty ? .empty : .content(filteredItems)
    }
    
    init(items: [Recipe] = [], recipeService: RecipeService) {
        self.items = items
        self.recipeService = recipeService
    }
    
    func loadRecipes() async {

        loadingTask?.cancel()
        
        if !items.isEmpty {
            return
        }
        
        loadSavedRecipes()
        
        if !items.isEmpty {
            return
        }
        
        loadingTask = Task {
            isLoading = true
            errorString = nil
            
            defer {
                isLoading = false
                loadingTask = nil
            }
            
            do {
                try Task.checkCancellation()
                items = try await recipeService.obtainRecipes()
                errorString = nil
                saveRecipes()
            } catch {
                errorString = "Failed to load recipes: \(error.localizedDescription)"
            }
        }
        
        await loadingTask?.value
    }
    
    func refreshRecipes() async {
        items = []
        await loadRecipes()
    }
    
    func add(_ recipe: Recipe) {
        items.insert(recipe, at: 0)
        saveRecipes()
    }
    
    func update(_ recipe: Recipe) {
        guard let index = items.firstIndex(where: { $0.id == recipe.id }) else { return }
        items[index] = recipe
        saveRecipes()
    }
    
    func remove(_ recipe: Recipe) {
        guard let index = items.firstIndex(of: recipe) else { return }
        items.remove(at: index)
        saveRecipes()
    }
    
    private func saveRecipes() {
        do {
            let encoded = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encoded, forKey: recipesKey)
        } catch {
            print("Failed to save recipes: \(error)")
        }
    }
    
    func loadSavedRecipes() {
        guard let savedData = UserDefaults.standard.data(forKey: recipesKey) else { return }
        
        do {
            let decoded = try JSONDecoder().decode([Recipe].self, from: savedData)
            items = decoded
        } catch {
            print("Failed to load saved recipes: \(error)")
        }
    }
}
