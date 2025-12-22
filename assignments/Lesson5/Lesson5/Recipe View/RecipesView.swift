//
//  RecipesView.swift
//  Lesson5
//
//  Created by Timur Minkhatov on 05.11.2025.
//

import SwiftUI
 
struct RecipesView: View {
    @Bindable var viewModel: RecipesViewModel
    
    @State private var showAdd = false
    
    private let grid = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                bodyContent
                    .padding()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    sortMenu
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    filterMenu
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddRecipeSheet { recipe in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        viewModel.add(recipe)
                    }
                }
                .presentationDetents([.medium, .large])
            }
            .refreshable {
                await viewModel.refreshRecipes()
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.sortOption) {
                ForEach(RecipesViewModel.SortOption.allCases, id: \.self) { option in
                    Label(option.rawValue, systemImage: sortIcon(for: option))
                        .tag(option)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down.circle")
        }
    }
    
    private var filterMenu: some View {
        Menu {
            Button {
                viewModel.selectedCategory = nil
            } label: {
                Label("All Categories", systemImage: viewModel.selectedCategory == nil ? "checkmark" : "")
            }
            
            Divider()
            
            ForEach(Recipe.categories, id: \.self) { category in
                Button {
                    viewModel.selectedCategory = category
                } label: {
                    Label(category, systemImage: viewModel.selectedCategory == category ? "checkmark" : "")
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
    
    private func sortIcon(for option: RecipesViewModel.SortOption) -> String {
        switch option {
        case .title:
            return "textformat"
        case .category:
            return "tag"
        case .dateAdded:
            return "clock"
        }
    }
    
    @ViewBuilder
    private var bodyContent: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: 150)
                
        case .error(let errorMessage):
            ErrorStateView(message: errorMessage)
            
        case .empty:
            EmptyStateView(
                title: viewModel.searchText.isEmpty ? "No recipes" : "No results",
                subtitle: viewModel.searchText.isEmpty ? "Add your first recipe" : "Try a different search"
            )
            
        case .content(let recipes):
            LazyVGrid(columns: grid) {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe, viewModel: viewModel)
                    } label: {
                        RecipeCardView(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                    .contextMenu {
                        Button {
                            showAdd = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.remove(recipe)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: recipes.count)
        }
    }
}
