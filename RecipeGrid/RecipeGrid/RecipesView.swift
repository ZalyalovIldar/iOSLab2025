//
//  ContentView.swift
//  RecipeGrid
//
//  Created by Artur Bagautdinov on 03.12.2025.
//

import SwiftUI

struct RecipesView: View {
    
    @State private var viewModel = RecipesViewModel()
    private let grid = [GridItem(.adaptive(minimum: 140), spacing: 16)]
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: grid) {
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
                .navigationTitle("Recipes")
            }
            .toolbar {
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
        .searchable(text: $viewModel.searchText, prompt: "Search Recipes")
    }
}

#Preview {
    RecipesView()
}
