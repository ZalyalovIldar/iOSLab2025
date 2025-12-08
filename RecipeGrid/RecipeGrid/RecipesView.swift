//
//  ContentView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import SwiftUI

struct RecipesView: View {
    
    @State private var viewModel = RecipesViewModel()
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isLandscape = geo.size.width > geo.size.height
                let columns = [
                    GridItem(.adaptive(minimum: isLandscape ? 220 : 140), spacing: 16)
                ]
                
                ScrollView {
                    if viewModel.filteredItems.isEmpty {
                        EmptyStateView(
                            title: "No Recipes Found",
                            message: "Try adding a new recipe or adjusting your search.",
                            systemImage: "book.closed"
                        )
                        .padding(.top, 60)
                    } else {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.filteredItems, id: \.id) { item in
                                if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                    NavigationLink(destination: RecipeDetailAndEditView(recipe: $viewModel.items[index])) {
                                        RecipeCardView(recipe: viewModel.items[index])
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    viewModel.remove(item)
                                                } label: {
                                                    Text("Delete")
                                                }
                                            }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Sort by", selection: $viewModel.sortOption) {
                                Text("Default").tag(RecipesViewModel.SortOption.none)
                                Text("A → Z").tag(RecipesViewModel.SortOption.alphabetical)
                                Text("Category").tag(RecipesViewModel.SortOption.category)
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    CreateRecipeView(viewModel: viewModel)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Recipes")
    }
}

#Preview {
    RecipesView()
}
