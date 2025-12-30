 //
//  RecipeView.swift
//  Recipe Grid
//
//  Created by Azamat Zakirov on 25.12.2025.
//

import SwiftUI

struct RecipeView: View {
    @Bindable var viewModel: RecipeViewModel
    
    @State private var showAddView = false
    @State private var recipeToEdit: Recipe?
    @State private var selectedRecipe: Recipe?
    
    private let grid = [GridItem(.adaptive(minimum: 140), spacing: 12)]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    if !viewModel.availableCategories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.availableCategories, id: \.self) { category in
                                    Button {
                                        viewModel.selectedCategory = category == "All" ? nil : category
                                    } label: {
                                        Text(category)
                                            .font(.subheadline)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                (viewModel.selectedCategory == category || 
                                                 (category == "All" && viewModel.selectedCategory == nil)) 
                                                ? Color.blue : Color.gray.opacity(0.2)
                                            )
                                            .foregroundColor(
                                                (viewModel.selectedCategory == category || 
                                                 (category == "All" && viewModel.selectedCategory == nil)) 
                                                ? .white : .primary
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(RecipeViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                Divider()
                
                ScrollView {
                    bodyContent
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Recipes")
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddView.toggle()
                    }
                    label: {
                        Label("Add Recipe", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                AddRecipeSheet { recipe in
                    viewModel.add(recipe)
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(item: $recipeToEdit) { recipe in
                AddRecipeSheet(
                    recipeToEdit: recipe,
                    onAdd: { _ in },
                    onEdit: { updatedRecipe in
                        viewModel.update(updatedRecipe)
                    }
                )
                .presentationDetents([.medium, .large])
            }
            .navigationDestination(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    @ViewBuilder private var bodyContent: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: 150)
        case .error(let errorMessage):
            ErrorStateView(message: errorMessage)
        case .empty:
            EmptyStateView(
                title: "No Recipes Found", 
                subtitle: viewModel.searchText.isEmpty && viewModel.selectedCategory == nil 
                    ? "Tap + to add your first recipe" 
                    : "Try adjusting your search or filters"
            )
        case .content(let recipes):
            LazyVGrid(columns: grid) {
                ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                    RecipeCardView(recipe: recipe)
                        .onTapGesture {
                            selectedRecipe = recipe
                        }
                        .contextMenu {
                            Button {
                                selectedRecipe = recipe
                            } label: {
                                Label("View Details", systemImage: "eye")
                            }
                            
                            Button {
                                recipeToEdit = recipe
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.remove(recipe)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: recipes.map { $0.id })
        }
    }
}
