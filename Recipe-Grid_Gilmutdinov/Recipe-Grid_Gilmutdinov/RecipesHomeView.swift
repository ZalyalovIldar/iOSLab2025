import SwiftUI

struct RecipesHomeView: View {
    @State private var allRecipes: [Recipe] = Recipe.demo
    @State private var query: String = ""
    @State private var showNewRecipeSheet = false

    private let gridColumns = [
        GridItem(.adaptive(minimum: 170), spacing: 16)
    ]
    
    private var visibleRecipes: [Recipe] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return allRecipes
        }
        
        let lower = trimmed.lowercased()
        
        return allRecipes.filter { item in
            item.title.lowercased().contains(lower) ||
            item.category.lowercased().contains(lower)
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if visibleRecipes.isEmpty {
                    if allRecipes.isEmpty {
                        EmptyPlaceholderView(
                            title: "Нет рецептов",
                            subtitle: "Создайте первый рецепт с помощью кнопки «+»."
                        )
                    } else {
                        EmptyPlaceholderView(
                            title: "Не найдено",
                            subtitle: "Попробуйте изменить запрос или добавьте новый рецепт."
                        )
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(visibleRecipes) { recipe in
                                RecipeTileView(recipe: recipe) {
                                    remove(recipe)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Мои рецепты")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewRecipeSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Поиск по названию или категории")
            .sheet(isPresented: $showNewRecipeSheet) {
                NewRecipeSheet { newItem in
                    allRecipes.append(newItem)
                }
            }
        }
    }
    
    private func remove(_ recipe: Recipe) {
        if let index = allRecipes.firstIndex(of: recipe) {
            allRecipes.remove(at: index)
        }
    }
}

#Preview {
    RecipesHomeView()
}
