//
//  ContentView.swift
//  IOS_LAB_HW5
//
//  Created by krnklvx on 03.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var editingRecipe: Recipe?
    @State private var sortType = "Алфавит"
    @State private var selectedCategory = "Все"
    
    // получаем все категории из рецептов сначала только все потом добавляются уникальные
    var allCategories: [String] {
        var categories = ["Все"]
        for recipe in recipes {
            if !categories.contains(recipe.category) {
                categories.append(recipe.category)
            }
        }
        return categories.sorted()
    }
    
    // фильтр и сортировка рецептов
    var filteredRecipes: [Recipe] {
        var result = recipes
        
        // фильтр по поиску
        if !searchText.isEmpty {
            result = result.filter { recipe in
                recipe.title.lowercased().contains(searchText.lowercased()) ||
                recipe.category.lowercased().contains(searchText.lowercased())
            }
        }
        
        // фильтр по категории
        if selectedCategory != "Все" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        // сортировка
        if sortType == "Алфавит" {
            result.sort { $0.title < $1.title }
        } else {
            result.sort { $0.category < $1.category }
        }
        
        return result
    }
    
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                TextField("Поиск...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // фльтр по категориям
                Picker("Категория", selection: $selectedCategory) {
                    ForEach(allCategories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Ссртировка
                Picker("Сортировка", selection: $sortType) {
                    Text("Алфавит").tag("Алфавит")
                    Text("Категория").tag("Категория")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                if filteredRecipes.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        editingRecipe = recipe
                                    } label: {
                                        Label("Редактировать", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        remove(recipe)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()
                        .animation(.default, value: filteredRecipes.count)
                    }
                }
            }
            .navigationTitle("Рецепты")
            .toolbar {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddRecipeSheet { newRecipe in
                    recipes.append(newRecipe)
                    saveRecipes()
                }
            }
            .sheet(item: $editingRecipe) { recipe in
                AddRecipeSheet(recipe: recipe) { updatedRecipe in
                    for i in 0..<recipes.count {
                        if recipes[i].id == updatedRecipe.id {
                            recipes[i] = updatedRecipe
                            break
                        }
                    }
                    saveRecipes()
                }
            }
            .onAppear {
                loadRecipes()
            }
        }
    }
    
    func remove(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveRecipes()
    }
    
    func saveRecipes() {
        if let data = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(data, forKey: "savedRecipes")
        }
    }
    
    func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "savedRecipes") {
            if let loaded = try? JSONDecoder().decode([Recipe].self, from: data) {
                recipes = loaded
            }
        }
    }
}


#Preview {
    ContentView()
}
