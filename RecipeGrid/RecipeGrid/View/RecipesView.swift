//
//  RecipesView.swift
//  RecipeGrid
//
//  Created by Ляйсан on 3/12/25.
//

import SwiftUI

struct RecipesView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var recipeViewModel = RecipeViewModel()
    @State private var isAddRecipeSheetShown = false
   
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                background
                
                if recipeViewModel.recipes.isEmpty {
                    EmptyStateView() {
                        isAddRecipeSheetShown = true
                    }
                } else {
                    VStack(alignment: .leading) {
                        title
                        CategoryPicker(selectedCategory: $recipeViewModel.selectedCategory)
                            .padding(.horizontal)
                        recipes
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Menu {
                                Menu {
                                    contextMenu
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.up.arrow.down")
                                        Text("Sort by")
                                    }
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                        }
                        ToolbarItem {
                            addButton
                        }
                        ToolbarItem(placement: .bottomBar) {
                            searchBar
                        }
                    }
                }
            }
            .sheet(isPresented: $isAddRecipeSheetShown) {
                CreateRecipeView(recipeViewModel: recipeViewModel)
            }
        }
    }
    
    @ViewBuilder private var background: some View {
        Color.black.ignoresSafeArea()
        Circle()
            .fill(.orange)
            .blur(radius: 100)
            .offset(x: 0, y: -400)
    }
    
    private var recipes: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(recipeViewModel.filteredRecipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipeViewModel: recipeViewModel, recipeId: recipe.id)
                    } label: {
                        RecipeRowView(recipe: recipe)
                            .padding(5)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.caption)
                .padding(.leading)
            TextField("Search", text: $recipeViewModel.searchText)
                .foregroundStyle(recipeViewModel.searchText.isEmpty ? .lightGrey : .white)
        }
    }
    
    private var addButton: some View {
        Button {
            isAddRecipeSheetShown = true
        } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(.glassProminent)
        .tint(.orange.opacity(0.8))
    }
    
    private var contextMenu: some View {
        Section {
            Button {
                recipeViewModel.isSortedByTitle.toggle()
            } label: {
                HStack {
                    Image(systemName: recipeViewModel.isSortedByTitle ? "checkmark" : "")
                    Text("Title")
                }
            }
        }
    }
    
    private var title: some View {
        Text("Recipes")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .padding()
    }
}

#Preview {
    NavigationStack {
        RecipesView()
    }
}
