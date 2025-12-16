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
    
    @State private var highlightedID: UUID? = nil
    
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
                            systemImage: "book.closed",
                            isLandscape: isLandscape
                        )
                        .padding(.top, 60)
                    } else {
                        
                        LazyVGrid(columns: columns) {

                            ForEach(viewModel.items) { item in
                                if viewModel.filteredItems.contains(where: { $0.id == item.id }) {

                                    let isHighlighted = (item.id == highlightedID)

                                    NavigationLink(
                                        destination: RecipeDetailView(
                                            recipe: $viewModel.items[
                                                viewModel.items.firstIndex(where: { $0.id == item.id })!
                                            ]
                                        )
                                    ) {
                                        RecipeCardView(recipe: item)
                                            .scaleEffect(isHighlighted ? 1.05 : 1.0)
                                            .shadow(
                                                color: isHighlighted
                                                    ? Color.blue.opacity(0.6)
                                                    : Color.black.opacity(0.1),
                                                radius: isHighlighted ? 10 : 4,
                                                x: 0,
                                                y: 2
                                            )
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    
                                                    viewModel.remove(item)
                                                    
                                                } label: {
                                                    Text("Delete")
                                                }
                                            }
                                    }
                                    .buttonStyle(.plain)
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .padding()

                        .padding()
                    }
                }
                .onChange(of: viewModel.lastAddedRecipeID) {
                    
                    highlightedID = viewModel.lastAddedRecipeID
                    
                    withAnimation(.spring(response: 3, dampingFraction: 0.7)) {
                        highlightedID = nil
                    }
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.08),
                            Color.blue.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .navigationTitle("Recipes")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarLeading) {
                            Menu {
                                categorySection
                                sortSection
                                resetSection
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                    )
                                    .font(.title2)
                            }
                        }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                )
                                .font(.title2)
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
    
    private var categorySection: some View {
        
        Group {
            
            Text("Category")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Picker("Category", selection: $viewModel.selectedCategory) {
                
                Text("All").tag(String?.none)
                
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category).tag(String?(category))
                }
            }
        }
    }

    private var sortSection: some View {
        
        Group {
            
            Text("Sort by")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Section("Sort by") {
                Picker("Sort by", selection: $viewModel.sortOption) {
                    Text("Default").tag(RecipesViewModel.SortOption.none)
                    Text("A → Z").tag(RecipesViewModel.SortOption.alphabetical)
                    Text("Category").tag(RecipesViewModel.SortOption.category)
                }
            }
        }
    }

    private var resetSection: some View {
        
        Section {
            
            Button(role: .destructive) {
                viewModel.selectedCategory = nil
                viewModel.sortOption = .none
            } label: {
                Text("Reset Filters")
            }
        }
    }

}

#Preview {
    RecipesView()
}
